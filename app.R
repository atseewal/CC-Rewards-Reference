library(shiny)
library(shinydashboard)
library(DBI)

cc_rewards_db <- dbConnect(RSQLite::SQLite(), "cc_rewards_db.sqlite")

# Helper Functions --------------------------------------------------------

#TODO - Generate function
generate_cheat_sheet <- function() {
    # Query the CC database for all cards and rewards
    # only keep unique rewards rows, based on highest reward
    # order cards alphabetically

    # Create the blank card template

    # For each card, add its image to the template, working through the available spots

    # For the list of stores for each card, take the available grid space for store logos,
    # determine the grid size, add each logo

    # each logo should have the reward percentage super imposed on top of it

    # Follow the bernie sits app pattern for how to return and display this image

    return(0)
}

# Server ------------------------------------------------------------------

server <- function(input, output) {
    # Button Events
    observeEvent(input$cc_table_cell_edit, {
        # Keep these in case performance is slow writing the entire table every edit
        row <- input$cc_table_cell_edit$row
        col <- input$cc_table_cell_edit$col

        temp <- dbGetQuery(cc_rewards_db, "select * from credit_card_table")
        temp[row, col] <- input$cc_table_cell_edit$value

        dbWriteTable(cc_rewards_db, "credit_card_table", temp, overwrite = TRUE)
        print("Writing changes to table")
    })
    #observeEvent(input$generate, {
        output$image <- renderImage({

            query_text <- paste0("SELECT image_path from credit_card_table where card_id = ", input$card_id)
            #print(query_text)
            image_path <- dbGetQuery(cc_rewards_db, query_text)[[1]]
            #print(image_path)
            list(src = image_path)
        }, deleteFile = FALSE)
    #})

    #output$cc_table <- renderTable(dbGetQuery(cc_rewards_db, "select * from credit_card_table"))
    output$cc_table <- renderDataTable(dbGetQuery(cc_rewards_db, "select * from credit_card_table"), editable = TRUE)
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
                    DT::dataTableOutput("cc_table")
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