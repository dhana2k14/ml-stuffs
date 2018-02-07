if (!require('RWordPress'))
  install.packages('RWordPress', repos = 'http://www.omegahat.org/R', type = 'source')
library(RWordPress)
options(WordpressLogin = c(user = 'password'),
        WordpressURL = 'http://user.wordpress.com/xmlrpc.php')
library(knitr)
knit2wp('yourfile.Rmd', title = 'Your post title')

vignette("extending-ggplot2")
