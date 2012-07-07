Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '284965234915707', 'dc4edb900edf70c616fa17e02ffab3e2'
  #localhost:
  #provider :facebook, '374173972605348', '051ce658b0a390eb9785c630129fc44e'
end
