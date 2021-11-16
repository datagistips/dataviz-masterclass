getColorForHue <- function(h, c = 50, l = 80) {
  hcl(h = h, c = c, l = l, fixup = TRUE)
}

getStatsComm <- function(f, codesInsees) {
  fComms <- f %>% 
    filter(idcom %in% codesInsees) %>% 
    summarize(idcom = list(idcom),
              idcomtxt = list(idcomtxt),
              iddep = list(iddep),
              iddeptxt = list(iddeptxt),
              idreg = list(idcom),
              idregtxt = list(idregtxt),
              arthab0920 = sum(arthab0920),
              artact0920 = sum(artact0920),
              artmix0920 = sum(artmix0920),
              artinc0920 = sum(artinc0920),
              surfcom20 = sum(surfcom20))
  
  fCommsLong <- gather(fComms, 
                       "variable", 
                       "value",
                       c("arthab0920", "artact0920", "artmix0920", "artinc0920", "surfcom20"))
  
  return(fCommsLong)
}

makePlot <- function(f, codesInsees) {
  
  # Filtre des données
  myStats <- f %>% 
    getStatsComm(codesInsees) %>% 
    filter(str_detect(variable, "art")) # Pas la colonne surfcom20
  
  # Libellés
  myStats <- myStats %>% mutate(variable = case_when(
    variable == "arthab0920" ~ "Habitat",
    variable == "artact0920" ~ "Activité",
    variable == "artmix0920" ~ "Mixte",
    variable == "artinc0920" ~ "Inconnu",
  ))
  
  # Surfaces en Ha
  myStats$value <- myStats$value / 10000
  
  # Ordre des barres
  # Les plus grands flux en premier
  myStats$variable <- as.character(myStats$variable)
  myLevels <- myStats$variable[order(myStats$value)]
  myStats$variable <- factor(myStats$variable, levels = myLevels)
  
  # Couleurs
  palette <- c("Habitat"  = colorBlue, 
               "Activité" = colorRed, 
               "Mixte"    = colorMagenta, 
               "Inconnu"  = colorGrey)
  
  # Plot
  ggplot(data = myStats, 
         aes(x = variable, 
             y = value,
             fill = variable)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    theme(
      axis.text.y=element_blank(),
      axis.ticks.y=element_blank(),
      axis.title.x=element_blank(),
      axis.title.y=element_blank(),
      panel.background=element_blank(),
      panel.border=element_blank(),
      panel.grid.major=element_blank(),
      panel.grid.minor=element_blank(),
      legend.position="bottom",
      legend.title=element_blank(),
      legend.text=element_text(size = 15)) +
    scale_y_continuous(sec.axis = dup_axis()) +
    scale_y_log10() +
    scale_fill_manual(
      name = "Flux\nd'artificialisation\n2009-2020",
      labels = myLevels,
      values = palette[myLevels],
      guide = guide_legend(reverse = TRUE)
    )
}

getTotalPcArt <- function(f, codesInsees) {
  f %>% 
    filter(idcom %in% codesInsees) %>% 
    summarize(value = mean(as.numeric(artcom0920)))
}

makeTotalPlot <- function(f, codesInsees) {
  
  myStats <- getTotalPcArtc(f, codesInsees)
  
  ggplot(myStats, aes(x = 1, 
                      y = value), 
         fill="black") + 
    geom_bar(stat="identity", width = 0.2) +
    geom_text(aes(label = paste(ceiling(value), "%")), hjust = -0.4) +
    scale_y_continuous(position = "right", 
                       limits = c(0,
                                  max(as.numeric(f$artcom0920), 
                                      na.rm = TRUE) )) +
    coord_flip() +
    theme(
      axis.text.y=element_blank(),
      axis.ticks.y=element_blank(),
      axis.title.x=element_blank(),
      axis.title.y=element_blank(),
      panel.background=element_blank(),
      panel.border=element_blank(),
      panel.grid.major=element_blank(),
      panel.grid.minor=element_blank(),
      legend.position="bottom",
      legend.title=element_blank(),
      legend.text=element_text(size = 6))
}

getCommsInBB <- function(comms2, xmin, ymin, xmax, ymax) {
  bb <- st_bbox(c(xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax), crs = st_crs(4326)) %>% st_as_sfc
  i <- comms2 %>% st_intersects(bb)
  w <- which(sapply(i, function(x) length(x) != 0))
  codesInsees <- comms2 %>% slice(w) %>% pull(INSEE_COM)
  codesInsees
}

makeStream <- function(flux, codeInsee) {
  
  df <- flux %>% getStatsFlux(codeInsee)
  
  # L'ordre des inverse dans les streamgraphs
  df$type <- factor(df$type, levels = c("Inconnu", "Mixte", "Activité", "Habitat"))
  
  # Plot
  df %>%
    streamgraph("type", "value", "year", sort = FALSE, height = '350px') %>%
    sg_axis_x(1, "Année", "%Y") %>% 
    sg_fill_manual(rev(myPalette))
}

makeTreemap <- function(f, codesInsees) {
  df <- getStatsComm(f, codesInsees) %>% filter(str_detect(variable, "^art"))
  
  df$variable <- case_when(
    df$variable == "arthab0920" ~ "Habitat",
    df$variable == "artact0920" ~ "Activité",
    df$variable == "artmix0920" ~ "Mixte",
    df$variable == "artinc0920" ~ "NC"
  )
  
  labels = df$variable
  parents = rep("", nrow(df))
  values = df$value
  
  fig <- plot_ly(
    type="treemap",
    labels=labels,
    parents=parents,
    values=values,
    marker=list(colors=pal))
  
  fig
}

getStatsFlux <- function(flux, codeInsee) {
  
  myCols <-  names(flux)[grep("^art[0-9]{2}\\S+[0-9]{2}$", names(flux))]
  
  # Filtre par commune
  df <- flux %>% filter(idcom == codeInsee) 
  
  # Colonnes intéressantes
  df <- df[, c("idcom", "idcomtxt", myCols)]
  
  # Long format
  df <- df %>% gather("variable", # key
                      "value",    # value
                      myCols) # variables
  
  # Année et type
  df$year <- gsub("art([0-9]{2})(\\S+)[0-9]{2}", "20\\1", df$variable)
  df$type <- gsub("art([0-9]{2})(\\S+)[0-9]{2}", "\\2", df$variable)
  
  # Renomme les valeurs de type
  df <- df %>% mutate(type = case_when(
    type == "hab" ~ "Habitat",
    type == "act" ~ "Activité",
    type == "mix" ~ "Mixte",
    type == "inc" ~ "Inconnu"))
  
  # Réagence les colonnes
  df <- df[, c("idcom", "idcomtxt", "year", "type", "value")]
  
  return(df)
}