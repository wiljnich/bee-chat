library(shiny)

shinyUI(
  bootstrapPage(
    includeCSS("shinychat.css"),
    
    includeScript("sendOnEnter.js"),

    div(
      class = "container-fluid", 
      div(class = "row-fluid",
          tags$head(tags$title("Bee Chat")),
          div(class="span-6", style="padding: 10px 0px;",
              div(class='column2',
                  h1("Bee Chat"), 
                  h4("Ya like jazz?")),
              div(class='column1',
                img(src='bbb.png', height=100))
          )
          
      ),
      div(
        class = "row-fluid", 
        mainPanel(
          uiOutput("chat"),
            fluidRow(
            div(class="span10",
              textInput("entry", "")
            ),
            div(class="span2",
                actionButton("send", "Send")
            )
          )
        ),
        sidebarPanel(id='sidebar',
          textInput("user", "Your Bee Name:", value=""),
          tags$hr(),
          h5("Bees in the Hive"),
          uiOutput("userList"),
          tags$hr(),
          tags$audio(src = "Im dreaming.mp3", type = "audio/mp3")
        )
      )
    )
  )
)
