## 4 Novembre
Pour ne pas avoi de marge entre le graphique et l'axe

	scale_y_continuous(limits = c(0,101), expand = c(0, 0))

Pas de grilles

	hw_plot +
	  theme(
	    panel.grid.major.x = element_blank(),
	    panel.grid.minor.x = element_blank()
	  )

## 3 Novembre
revert legend

	scale_fill_discrete(
	    name = "Flux\nd'artificialisation\n2009-2020",
	    labels = myLevels,
	    guide = guide_legend(reverse = TRUE)
	  )
datanovia

tutos R ggplot

duplicate axis
	scale_y_continuous(sec.axis = dup_axis())

streamgraph et sort

	sort = FALSE
transform log

	scale_y_log10()


single bar chart

	ggplot(ddf, aes(1, var2, fill=var1)) + geom_bar(stat="identity")

scale_y_continuous
	scale_y_continuous(limits=c(0, 1200), breaks=c(0, 400, 800, 1200))

summarise_all

Plotly et couleurs

	marker=list(
	                colors=junio_ipc$yoy,


## 2 Novembre
legend title
p + theme(legend.position=c(0.85, 0.3),legend.title=element_text(size=14))

background
panel.background = element_rect(fill = "lightblue",
                                colour = "lightblue",
                                size = 0.5, linetype = "solid")

change only labels
ggplot(mtcars, aes(x=hp,color=factor(cyl)))+
    geom_density()+
    scale_color_discrete(name="Cylinders",
                         labels=c("4 Cylinder","6 Cylinder","8- Cylinder"))

relevel
data$Treatment <- as.character(data$Treatment)
#Then turn it back into a factor with the levels in the correct order
data$Treatment <- factor(data$Treatment, levels=unique(data$Treatment))

colorspace
https://cran.r-project.org/web/packages/colorspace/vignettes/colorspace.html
https://colorspace.r-forge.r-project.org/articles/colorspace.html

label centered
position = position_stack(vjust = 0.5)

geom_text(aes(label = paste0(Proportion, "%")),
            position = position_stack(vjust = 0.5))

blank
+ theme(axis.line=element_blank(),axis.text.x=element_blank(),
          axis.text.y=element_blank(),axis.ticks=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank(),legend.position="none",
          panel.background=element_blank(),panel.border=element_blank(),panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),plot.background=element_blank())

gather
gather(df, "variable", "value", -c("arthab", "artact", "artmix", "artinc"))
