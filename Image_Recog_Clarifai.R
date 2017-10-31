
# Clarifai - An Advanced image recognition and machine learning platform

require(devtools)
devtools::install_github('sooduku/clarifai', build_vignettes = T)

install.packages('clarifai')
require(clarifai)

## Sign up at Clarifai (https://developer.clarifai.com/) and get API token details

secret_id(c('T3DIgYtEokkSCQnGMNpd58cofZZJ123zmpJpbiHy','LgpBH4KHlSx0MVtu1dte-N10eIxlBwm_HPhW627z'))
get_token()

# Load image

res <- tag_image_urls("D:\\Kaggle\\OCR\\Watermark\\1.jpg")
head(res)

