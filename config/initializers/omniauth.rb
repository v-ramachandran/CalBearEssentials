Rails.application.config.middleware.use OmniAuth::Builder do

  if Rails.env.production?
    provider :facebook, '284965234915707', 'dc4edb900edf70c616fa17e02ffab3e2'
  elsif Rails.env.development?
    #localhost:
    provider :facebook, '374173972605348', '051ce658b0a390eb9785c630129fc44e'
  end
end
