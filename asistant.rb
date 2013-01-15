require 'logger'

logger = Logger.new($stdout)
logger.level = Logger::INFO

require 'mechanize'

loop do
  agent = Mechanize.new
  agent.log = logger

  page = agent.get 'https://www.liberty.edu/index.cfm?PID=13627'

  page = page.form_with(name: 'loginform').tap do |login_form|
    login_form.username = ENV['LIBERTY_USERNAME']
    login_form.password = ENV['LIBERTY_PASSWORD']
  end.submit

  page.search('meta[http-equiv=Set-Cookie]').each do |set_cookie|
    Mechanize::Cookie.parse(page.uri, set_cookie.attributes['content'].value).each do |cookie|
      agent.cookie_jar.add(page.uri, cookie)
    end
  end

  refresh = Mechanize::Page::MetaRefresh.from_node(page.search('meta[http-equiv=refresh]').first, page, page.uri)

  agent.ssl_version = 'SSLv3'
  page = agent.get(refresh.href)

  page = page.link_with(text: 'Student').click

  page = page.link_with(text: 'Registration').click

  page = page.link_with(text: 'Add or Drop Courses').click

  page = page.form_with(action: '/livedata/bwskfreg.P_AltPin').tap do |term_form|
    term_form.field_with(name: 'term_in').option_with(text: Regexp.new(Regexp.quote(ENV['LIBERTY_TERM']))).select
  end.submit

  class_form = page.form_with(action: '/livedata/bwckcoms.P_Regs')
  ENV['LIBERTY_CRNS'].split(',').each do |crn|
    class_form.field_with(name: 'CRN_IN', value: '').value = crn
  end
  page = class_form.submit(class_form.button_with(value: 'Submit Changes'))

  if (errors = page.search('.datadisplaytable[summary="This layout table is used to present Registration Errors."]').first)
    errors.search('tr:gt(1)').each do |row|
      logger.info "Result: #{row.search('td').map(&:text).map(&:strip).inspect}"
    end
  else
    logger.info 'Result: Registered!?'
  end

  sleep 10
end
