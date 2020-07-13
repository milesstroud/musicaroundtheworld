library(ggplot2)
install.packages("wesanderson")
library(wesanderson)
musica <- read.csv("/Users/ashley/Downloads/data 2.csv")

#Creating empty columns of NAs for a Python for loop to fill with the scraped data later
musica[,"Danceability"] <- NA
musica[,"Duration"] <- NA
musica[,"Instrumentalness"] <- NA
musica[,"Speechiness"] <- NA
musica[,"Tempo"] <- NA

#Separating music dataframe by North American region (only including Canada and USA), and Great Britan
us <- subset(musica, musica$Region == 'us')
ar <- subset(musica, musica$Region == 'ar')
gb <- subset(musica, musica$Region == 'gb')

#Getting the first 10 days of each dataset (otherwise it's a loooot of data!)
us <- us[1:2000,]
#Including non-NA country (ar), after preliminary analysis and determining the US and GB are very similar
gb <- gb[1:2000,]
ar <- ar[1:2000,]
#Binding the two datasets vertically
musica <- rbind(us, gb)
musica <- rbind(musica, ar)

#Regular expression to remove the extraneous characters in the track ID, which is located at the end 
#of the URL
musica$URL <- regmatches(musica$URL, regexpr("[0-9].*", musica$URL, perl = TRUE))

#Writing a CSV for later use in Python by Pandas (commented out for sourcing)
#write.csv(musica, "/Users/ashley/Documents/Music_Data.csv")

#Reading in the data after scraping quantitative measures about each of the 6000 songs using
#Spotipy package in Python
dailyfeatures <- read.csv('/Users/ashley/Documents/Music_Data(pandas).csv')

#Analyses
summary(lm(dailyfeatures$Position ~ dailyfeatures$Speechiness))

ahh<- ggplot(data.frame(dailyfeatures$Position, dailyfeatures$Speechiness), aes(x=dailyfeatures$Position, y=dailyfeatures$Speechiness)) +  geom_point() + geom_smooth(method="lm", color="yellow")

ahh2 <- ggplot(data.frame(dailyfeatures$Position, dailyfeatures$Danceability), aes(x=dailyfeatures$Position, y=dailyfeatures$Danceability)) +  geom_point() + geom_smooth(method="lm", color="yellow") + xlab("Top 200 Position") + ylab("Danceability") + ggtitle("Danceability in Relation to Song Chart Position")

summary(lm(dailyfeatures$Position ~ dailyfeatures$Danceability))


us_usa <- subset(dailyfeatures$Speechiness,dailyfeatures$Region == 'us')
arg <- subset(dailyfeatures$Speechiness, dailyfeatures$Region == 'ar')
gbsux <- subset(dailyfeatures$Speechiness, dailyfeatures$Region == 'gb')

us_usa2 <- subset(dailyfeatures$Instrumentalness,dailyfeatures$Region == 'us')
arg2 <- subset(dailyfeatures$Instrumentalness, dailyfeatures$Region == 'ar')
gbsux2 <- subset(dailyfeatures$Instrumentalness, dailyfeatures$Region == 'gb')



mean(us_usa)
mean(arg)
mean(gbsux)
sd(gbsux)
sd(us_usa)
sd(arg)


t.test(us_usa, gbsux)

t.test(us_usa2, gbsux2)


# (Predominantly) English Speaking vs. Non-English Speaking
Eng1 <- subset(dailyfeatures$Speechiness, dailyfeatures$Region == 'gb')
Eng2 <- subset(dailyfeatures$Speechiness, dailyfeatures$Region == 'us')
English <- rbind(Eng1, Eng2)

t.test(English, arg)

#Viz
dotty <- ggplot(data.frame(dailyfeatures$Position, dailyfeatures$Speechiness), aes(fill = dailyfeatures$Region, x=dailyfeatures$Position, y=dailyfeatures$Speechiness)) +
  geom_point(color = "#FF9933",position='jitter')+
  facet_wrap( ~ dailyfeatures$Region) +
  xlab('Top 200 Position') +
  ylab('Speechiness Rating')+
  ggtitle('Song Speechiness Rating by Country')+
  guides(fill=guide_legend(title="Region"))

dotty
ggsave("dotty.png")
dotty2 <- ggplot(data.frame(dailyfeatures$Position, dailyfeatures$Instrumentalness), aes(fill = dailyfeatures$Region, x=dailyfeatures$Position, y=dailyfeatures$Instrumentalness)) +
  geom_point(color = "#FF9933",position='jitter')+
  facet_wrap( ~ dailyfeatures$Region) +
  xlab('Top 200 Position') +
  ylab('Instrumentalness Rating')+
  ggtitle('Song Instrumentalness Rating by Country')+
  guides(fill=guide_legend(title="Region"))

dotty2

BarsData <- aggregate(dailyfeatures, by = list(dailyfeatures$Region), FUN = mean)
colnames(BarsData)[1] <- "Country"
barz <- ggplot(BarsData, aes(fill = Country, x=Country, y = BarsData$Speechiness)) +
  geom_bar(stat='identity') +
  ggtitle("Average Song Speechiness by Country") +
  ylab("Speechiness") +
  scale_fill_brewer(palette="Oranges") +
  theme_minimal()


barz        

barz2 <- ggplot(BarsData, aes(fill = Country, x=Country, y = BarsData$Instrumentalness)) +
  geom_bar(stat='identity') +
  ggtitle("Average Song Instrumentalness by Country") +
  ylab("Instrumentalness") +
  scale_fill_brewer(palette="Reds") +
  theme_minimal()

barz2

