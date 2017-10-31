install.packages("tm")
install.packages("twitterR")
library(tm)
library(twitteR)
tweets <- searchTwitter("Chennai Express", n = 500, lang = 'eng')

api_key <- 'CFVIkXKNhFxEDfsYrKhDMdgHg'
  api_secret <-'0vM0z9IEVyOUGwPPbItbDXZ52pPIrp4U5CrSIdqP1tG1UHhyYP'
  access_token <-'108613702-s9ZwtiY5LAUxc9IFBMbvnv6X78TM2rK4Qv0No84o'
  access_token_secret <-'qi9o8mdKI9mRMMel3f4LyszviSEJmoHM6O4Ge0UJBsu96'
  setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)