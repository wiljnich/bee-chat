library(shiny)

shinyUI(
  bootstrapPage(
    # We'll add some custom CSS styling -- totally optional
    includeCSS("shinychat.css"),
    
    includeScript("sendOnEnter.js"),
    #includeScript('bzz.js'),
    
    div(
      # Setup custom Bootstrap elements here to define a new layout
      class = "container-fluid", 
      div(class = "row-fluid",
          # Set the page title
          tags$head(tags$title("Bee Chat")),
          
          # Create the header
          div(class="span-6", style="padding: 10px 0px;",
              div(class='column2',
                  h1("Bee Chat"), 
                  h4("Ya like jazz?")),
              div(class='column1',
                img(src='bbb.png', height=100))
          )
          
      ),
      # The main panel
      div(
        class = "row-fluid", 
        mainPanel(
          # Create a spot for a dynamic UI containing the chat contents.
          uiOutput("chat"),
          
          # Create the bottom bar to allow users to chat.
          fluidRow(
            div(class="span10",
              textInput("entry", "")
            ),
            div(class="span2",
                actionButton("send", "Send")
            )
          )
        ),
        # The right sidebar
        sidebarPanel(id='sidebar',
          # Let the user define his/her own ID
          textInput("user", "Your Bee Name:", value=""),
          tags$hr(),
          h5("Bees in the Hive"),
          # Create a spot for a dynamic UI containing the list of users.
          uiOutput("userList"),
          tags$hr(),
          tags$audio(src = "Im dreaming.mp3", type = "audio/mp3")
        )
      )
    )
  )
)
