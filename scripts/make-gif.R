# http://rainnic.altervista.org/en/imagemagick-two-fast-methods-make-gif-images?language_content_entity=en

setwd("../..") # shiny-artif

# List frames
l <- list.files("notebooks/files/shinyapp/", "*.png")
n <- gsub("^([0-9]+)-.*", "\\1", l) %>% as.numeric
o <- order(n)
l2 <- l[o]
l3 <- l2[-c(13, 17, 18)] # exclude frame 13, 17, 18
l4 <- paste(l3, collapse=" ")

# GIF
setwd("notebooks/files/shinyapp/") # shiny-artif/files/shinyapp/

delay <- 50
cmd <- sprintf("C:\\ImageMagick-7.1.0-Q16-HDRI\\magick.exe -delay %d %s -morph 1 -loop 0 gif\\animation.gif", delay, l4)
system(cmd)

# Compress
setwd("gif") # # shiny-artif/files/shinyapp/gif

cmd <- "C:\\gifsicle-1.92-win64\\gifsicle-1.92 -O3 --lossy=80 --scale 0.8 animation.gif -o animation-compressed.gif"
system(cmd)