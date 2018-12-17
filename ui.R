#reactive values act as data streams that flow through your app, the input list is a list of reactive values 
#The values show current state of inputs,  


# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

#setwd("H:\\ISB\\Term-1\\Text Analytics\\Assignment\\PA-Code")

if (!require(udpipe)){install.packages("udpipe")}
if (!require(stringr)){install.packages("stringr")}
if (!require(shiny)){install.packages("shiny")}
if (!require(textrank)){install.packages("textrank")}
if (!require(lattice)){install.packages("lattice")}
if (!require(igraph)){install.packages("igraph")}
if (!require(ggraph)){install.packages("ggraph")}
if (!require(wordcloud)){install.packages("wordcloud")}
if (!require(readtext)){install.packages("readtext")}

#Including all the necessary libraries
library(shiny)
library(udpipe)
library(textrank)
library(lattice)
library(igraph)
library(ggraph)
library(ggplot2)
library(wordcloud)
library(stringr)


# Define UI for application that draws a histogram
shinyUI(
   fluidPage(theme = "bootstrap-dark.css",
       
  #Application Header CSS
  tags$head(
    tags$style(HTML("
                    @import url('//https://fonts.googleapis.com/css?family=Raleway:300,500');
                    
                    h1 {
                    font-family: 'Raleway';
                    font-weight: 400;
                    line-height: 1.1;
                    color: #1abc9c;
                    }
                    
                    "))
    ),
  
  #Application Header
  headerPanel("Text Analysis with UDPipe"),
  
  # Application title
  #titlePanel("UDPipe Text Analysis"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      
      fileInput("txtfile", "Choose a text file you want to analyse"),
      fileInput("udmfile", "Choose the UDPIPE MODEL file"),
      tags$hr(),
      
      #checkbox
      checkboxGroupInput("myupos",label = h4("Parts of Speech to Analyse:"),
                         c("Adjective" = "ADJ",
                           "Propernoun" = "PROPN",
                           "Adverb" = "ADV",
                           "Noun" = "NOUN",
                           "Verb"= "VERB"),
      #Default selection
      selected = c("ADJ","NOUN","VERB"),
      width = '100%'
      ),
      
      sliderInput("freq", "Minimum Frequency in Co-Occurance Graph:", min = 0,  max = 50, value = 30),
      sliderInput("freq1", "Minimum Frequency in wordcloud:", min = 0,  max = 50, value = 5),
      sliderInput("max1", "Maximum no of words in wordcloud:", min = 1,  max = 300, value = 100)
      ),
mainPanel(
  tabsetPanel(type = "tabs",
              tabPanel("Summary",h2(p("App Summary")),
                       p("This takes two input files. The data needs to be in text file and the UDPIPE model file must have the extension \".udpipe\".", align = "justify"),
                       p("The URL below contains the sample files."),
                       a(href="https://raw.githubusercontent.com/preetijp/repo/master/nokia.txt"
                         ,"Click here for sample files!"),
                       hr(),
                       h4("Application developed by:"),
                       p("Preeti Agarwal: PGID 11810054"),
                       p("Raman Teja Venigalla: PGID 11810027"),
                       p("Ashwani Prakash Singh: PGID 11810076"),
                       hr(),
                       h4("About the App"),
                       p("The app gives insights on the parts of speech for input data based on the language. It also provides display aids like wordcloud, co-occurance graphs, to better understand the underlying data."),
                       h4("Note:"),
                       p("Include the data and the UDPIPE model of the same language!"),
                       p("The visualisation/processing will only function after the input files are uploaded.")
              ),
              tabPanel("Annotate",dataTableOutput('Annotate')),
              tabPanel("Co-Occurance Plot", plotOutput("Cooccurance")),
              tabPanel("wordclouds",
                       h4("Nouns"),
                       plotOutput('plot1'),
                       h4("Verbs"),
                       plotOutput('plot2'),
                       h4("Adverbs"),
                       plotOutput('plot3'),
                       h4("Adjectives"),
                       plotOutput('plot4'),
                       h4("Propernouns"),
                       plotOutput('plot5'))
                    
              )
  
  )

)
))
