library(shiny)
library(shinydashboard)

# Server ------------------------------------------------------------------

server <- function(input, output) {
    # Button Events
    observeEvent(input$generate, {
        showNotification("This don't work yet, be patient", type = "message")
    })
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
            box(
                title = "Click Generate",
                width = 12,
                actionButton("generate", "Generate!"),
                footer = "Note: This is just a sample using my credit cards"
            ),
            box(title = "Output", width = 12, imageOutput("image"))
        ),
        tabItem(tabName = "update",
            box(title = "Nothing here yet...")
        )
    )
)

# Assemble App ------------------------------------------------------------

ui <- dashboardPage(header, sidebar, body)

shinyApp(ui, server)