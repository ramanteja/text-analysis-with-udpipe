#Server side code for R Shiny App

library(shiny)
library(readtext)
#Increasing the default maximum file upload size of 5 MB to 30 MB
options(shiny.maxRequestSize=30*1024^2)

#Let us initiate the server
shinyServer(function(input, output) {
  
  udmodel <- reactive({
    file2 = input$file_2$datapath
  })
  
  Dataset <- reactive({
    
    file1 = input$file_1
    if (is.null(file1$datapath)) { return(NULL) } else
    {
      
      require(stringr)
      #Data <- readLines(file1$datapath)
      Data <- readtext(file1$datapath, encoding = "UTF-8")
      Data  =  str_replace_all(Data, "<.*?>", "")
      return(Data)
      
    }
  })  
  
  an <- reactive({
    un_model = udpipe_load_model(input$file2$datapath)
    txt1 <- udpipe_annotate(un_model, Dataset())
    txt1 <- as.data.frame(txt1)
    return(txt1)
  })
  
  
  output$Annotate <- renderDataTable(
    {
      out <- an()
      return(out)
    }
  )
  
  output$Cooccurance <- renderPlot(
    {
      
      un_model = udpipe_load_model(input$file2$datapath)
      txt <- udpipe_annotate(un_model, Dataset())
      txt <- as.data.frame(txt)
      data_cooc <- udpipe::cooccurrence(x = subset(txt, upos %in% input$myupos), term = "lemma", 
                                        group = c("doc_id", "paragraph_id", "sentence_id")
                                        
      )
      library(igraph)
      library(ggraph)
      library(ggplot2)
      wordnetwork <- head(data_cooc, input$freq)
      wordnetwork <- igraph::graph_from_data_frame(wordnetwork)
      ggraph(wordnetwork, layout = "fr") + geom_edge_link(aes(width = cooc, edge_alpha = cooc), edge_colour = "orange") +
        geom_node_text(aes(label = name), col = "darkgreen", size = 4) +
        theme_graph(base_family = "Arial Narrow") +
        theme(legend.position = "none") +
        labs(title = "Cooccurrences within 3 words distance")
    }
  )
  
  
  output$plot1 = renderPlot({
    if('NOUN'  %in% input$myupos)
    {
      all_nouns = an() %>% subset(., upos %in% "NOUN") 
      top_nouns = txt_freq(all_nouns$lemma)
      wordcloud(words = top_nouns$key, 
                freq = top_nouns$freq, 
                min.freq = input$freq1, 
                max.words = input$max1,
                random.order = FALSE, 
                colors = brewer.pal(6, "Dark2"))
    } 
    else
    {return(NULL)}
  })
  
  output$plot2 = renderPlot({
    if('VERB'  %in% input$myupos)
    {
      all_verbs = an() %>% subset(., upos %in% "VERB") 
      top_verbs = txt_freq(all_verbs$lemma)
      wordcloud(words = top_verbs$key, 
                freq = top_verbs$freq, 
                min.freq = input$freq1, 
                max.words = input$max1,
                random.order = FALSE, 
                colors = brewer.pal(6, "Dark2"))
    } 
    else
    {return(NULL)}
    
  })
  
  
  output$plot3 = renderPlot({
    
    if('ADV'  %in% input$myupos)
    {
      all_adverbs = an() %>% subset(., upos %in% "ADV") 
      top_adverbs = txt_freq(all_adverbs$lemma)
      wordcloud(words = top_adverbs$key, 
                freq = top_adverbs$freq, 
                min.freq = input$freq1, 
                max.words = input$max1,
                random.order = FALSE, 
                colors = brewer.pal(6, "Dark2"))
    } 
    else
    {return(NULL)}
  })
  
  output$plot4 = renderPlot({
    
    if('ADJ'  %in% input$myupos)
    {
      all_adjec = an() %>% subset(., upos %in% "ADJ") 
      top_adjec = txt_freq(all_adjec$lemma)
      wordcloud(words = top_adjec$key, 
                freq = top_adjec$freq, 
                min.freq = input$freq1, 
                max.words = input$max1,
                random.order = FALSE, 
                colors = brewer.pal(6, "Dark2"))
    } 
    else
    {return(NULL)}
    
    
  })
  
  output$plot5 = renderPlot({
    
    if('PROPN'  %in% input$myupos)
    {
      all_adjec = an() %>% subset(., upos %in% "PROPN") 
      top_adjec = txt_freq(all_adjec$lemma)
      wordcloud(words = top_adjec$key, 
                freq = top_adjec$freq, 
                min.freq = input$freq1, 
                max.words = input$max1,
                random.order = FALSE, 
                colors = brewer.pal(6, "Dark2"))
    } 
    else
    {return(NULL)}
    
  })
  
})