library(shiny)
library(shinydashboard)
library(DBI)
library(magick)

cc_rewards_db <- dbConnect(RSQLite::SQLite(), "cc_rewards_db.sqlite")

# Helper Functions --------------------------------------------------------

#TODO - Generate function
generate_cheat_sheet <- function() {
    # Query the CC database for all cards and rewards
    # only keep unique rewards rows, based on highest reward
    # order cards alphabetically

    # Create the blank card template
    base_id <- magick_image_blank(width = 400, height = 246, color = '#000000')
    id_side = base_id

    # For each card, add its image to the template, working through the available spots
    # Find total space for card images
    cc_image_size = base_id$height / card_count

    # loop over card images and place them
    # Read card images in
    temp_card_image <- magick_read("Images/credit_cards")

    # Scale image
    temp_card_image <- magick_image_scale(temp_card_image/cc_image_size)

    # composite image onto base_id
    id_side = magic_composite(id_side, temp_card_image, offset="1")

    # For the list of stores for each card, take the available grid space for store logos,
    # determine the grid size, add each logo
    # Repeat similar steps to credit card images from above

    # each logo should have the reward percentage super imposed on top of it
    temp_store_logo <- magick_composite(temp_store_logo, offset="1") # or annote?

    # Follow the bernie sits app pattern for how to return and display this image

    return(0)
}

# Server ------------------------------------------------------------------

server <- function(input, output) {
    # Button Events
    observeEvent(input$cc_table_cell_edit, {
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