library(shiny)
library(stringr)

vars <- reactiveValues(chat=NULL, users=NULL)

if (file.exists("chat.Rds")){
  vars$chat <- readRDS("chat.Rds")
} else {
  vars$chat <- "Barry! Breakfast is ready!"
}
linePrefix <- function(){
  if (is.null(isolate(vars$chat))){
    return("")
  }
  return("<br />")
}

shinyServer(function(input, output, session) {
  sessionVars <- reactiveValues(username = "")
  init <- FALSE
  
  session$onSessionEnded(function() {
    isolate({
      vars$users <- vars$users[vars$users != sessionVars$username]
      vars$chat <- c(vars$chat, paste0(linePrefix(),
                     tags$span(class="user-exit",
                       sessionVars$username,
                       "wasted their sting on a squirrel.")))
    })
  })
  
  observe({
    input$user
    if (!init){
      sessionVars$username <- paste0('Worker Bee ', round(runif(1, 300, 999)))
      isolate({
        vars$chat <<- c(vars$chat, paste0(linePrefix(),
                        tags$span(class="user-enter",
                          sessionVars$username,
                          "buzzed in.")))
      })
      init <<- TRUE
    } else{
      isolate({
        if (input$user == sessionVars$username || input$user == ""){
          return()
        }
        vars$users <- vars$users[vars$users != sessionVars$username]

        vars$chat <<- c(vars$chat, paste0(linePrefix(),
                        tags$span(class="user-change",
                          paste0("\"", sessionVars$username, "\""),
                          " -> ",
                          paste0("\"", input$user, "\""))))
        
        sessionVars$username <- input$user
      })
    }
    isolate(vars$users <- c(vars$users, sessionVars$username))
  })
  
  observe({
    updateTextInput(session, "user", 
                    value=sessionVars$username)    
  })
  
  output$userList <- renderUI({
    tagList(tags$ul( lapply(vars$users, function(user){
      return(tags$li(user))
    })))
  })
  
  # Listen for input$send changes (i.e. when the button is clicked)
  observe({
    if(input$send < 1){
      return()
    }
    isolate({
      vars$chat <<- c(vars$chat, 
                      paste0(linePrefix(),
                        tags$span(class="username",
                          tags$abbr(title=Sys.time(), sessionVars$username)
                        ),
                        ": ",
                        tagList(input$entry)))
    })
    updateTextInput(session, "entry", value="")
  })
  
  output$chat <- renderUI({
    if (length(vars$chat) > 500){
      vars$chat <- vars$chat[(length(vars$chat)-500):(length(vars$chat))]
    }
    saveRDS(vars$chat, "chat.Rds")
    HTML(vars$chat)
  })
})
