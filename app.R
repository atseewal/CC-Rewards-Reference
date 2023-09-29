library(shiny)
library(shinydashboard)
library(DBI)

cc_rewards_db <- dbConnect(RSQLite::SQLite(), "cc_rewards_db.sqlite")

# Server ------------------------------------------------------------------

server <- function(input, output) {
    # Button Events
    #observeEvent(input$generate, {
        output$image <- renderImage({

            query_text <- paste0("SELECT image_path from credit_card_table where card_id = ", input$card_id)
            #print(query_text)
            image_path <- dbGetQuery(cc_rewards_db, query_text)[[1]]
            #print(image_path)
            list(src = image_path)
        }, deleteFile = FALSE)
    #})
    output$cc_table <- renderTable(dbGetQuery(cc_rewards_db, "select * from credit_card_table"))
}

# Header ------------------------------------------------------------------

header <- dashboardHeader(
    title = "Credit Card Reward Reference Generator"
)

# Sidebar -----------------------------------------------------------------

sidebar <- dashboardSidebar(
    sidebarMenu(
        menuItem("Generate", tabName = "generate", icon = icon("plus")),
        menuItem("Update", tabName = "update", icon = icon("pencil"))
    )
)

# Body --------------------------------------------------------------------

body <- dashboardBody(
    tabItems(
        tabItem(tabName = "generate",
            selectInput("card_id", "Card Number", choices = dbGetQuery(cc_rewards_db, "SELECT card_id from credit_card_table")),
            box(
                title = "Click Generate",
                width = 12,
                #actionButton("generate", "Generate!"),
                footer = "Note: This is just a sample using my credit cards"
            ),
            box(title = "Output", width = 12, imageOutput("image"))
        ),
        tabItem(tabName = "update",
            tabBox(#TODO https://stackoverflow.com/questions/42370227/display-image-in-a-data-table-from-a-local-path-in-r-shiny
                    #TODO https://stackoverflow.com/questions/70155520/how-to-make-datatable-editable-in-r-shiny w/ sql query to update the database immediately on edit or with action button to save (run relevant query)
                    # https://rsqlite.r-dbi.org/articles/rsqlite#queries for running entire database update queries
                tabPanel("credit_cards",
                    tableOutput("cc_table")
                ),
                tabPanel("rewards",
                    "Nothing here either..."
                )
            )
        )
    )
)

# Assemble App ------------------------------------------------------------

ui <- dashboardPage(header, sidebar, body)

shinyApp(ui, server)