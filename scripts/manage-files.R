# Copy notebooks files
l <- list.files("notebooks", "*.html|*.Rmd|*.rds|*.json|*.R|*.md", full.names = T)

destDir <- "../datagistips.github.io/dataviz-masterclass/"

for(from in l) {
  fileName <- gsub("^.*/(.*)$", "\\1", from)
  to <- file.path(destDir, fileName)
  file.copy(from, to, overwrite = T)
}

# Copy files dir.
file.copy("notebooks/files",
          destDir, 
          recursive = TRUE, overwrite = T)

# Copy archives dir.
file.copy("notebooks/archives", 
          "destDir", 
          recursive = TRUE, overwrite = T)
