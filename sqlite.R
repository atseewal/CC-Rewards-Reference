library(DBI)

# Connect to Database (or create if not already created)
cc_rewards_db <- dbConnect(RSQLite::SQLite(), "cc_rewards_db.sqlite")

# Initial Load of Credit Cards
card_id <- c(1, 2, 3, 4, 5)
card_name <- c(
    "American Express Preferred Cash Back",
    "American Express Gold Card",
    "Barclays View",
    "Chase Amazon Prime",
    "Target Store Card"
)
image_path <- c(
    "Images/credit_cards/blue-cash-preferred.webp",
    "Images/credit_cards/amex-gold-card.avif",
    "Images/credit_cards/barclays-view.webp",
    "Images/credit_cards/amazon-prime-rewards.png",
    "Images/credit_cards/target.webp"
)

credit_card_table <- data.frame(card_id = card_id, card_name = card_name, image_path = image_path, row.names = NULL)

dbWriteTable(cc_rewards_db, "credit_card_table", credit_card_table, overwrite = TRUE)

# Initial Load of Reward Categories
reward_id <- c(
    1, 2, 3, 4, 5, 6, 7, 8, 9,
    10, 11, 12, 13, 14, 15, 16, 17, 18,
    19, 20, 21, 22, 23, 24, 25, 26, 27,
    28, 29, 30, 31, 32, 33, 34, 35, 36
)
card_id <- c(
    1, 1, 1, 1, 1, 1, 1, 1, 1,
    2, 2, 2, 2, 2, 2, 2, 2, 2,
    3, 3, 3, 3, 3, 3, 3, 3, 3,
    4, 4, 4, 4, 4, 4, 4, 4, 4,
    5, 5, 5, 5, 5, 5, 5, 5, 5
)
category_id <- c(
    1, 2, 3, 4, 5, 6, 7, 8, 9,
    1, 2, 3, 4, 5, 6, 7, 8, 9,
    1, 2, 3, 4, 5, 6, 7, 8, 9,
    1, 2, 3, 4, 5, 6, 7, 8, 9,
    1, 2, 3, 4, 5, 6, 7, 8, 9
)
category_name <- c(
    "Amazon", "Bars", "Drugstore", "Flights", "Gas", "Groceries", "Restaurant", "Target", "Other",
    "Amazon", "Bars", "Drugstore", "Flights", "Gas", "Groceries", "Restaurant", "Target", "Other",
    "Amazon", "Bars", "Drugstore", "Flights", "Gas", "Groceries", "Restaurant", "Target", "Other",
    "Amazon", "Bars", "Drugstore", "Flights", "Gas", "Groceries", "Restaurant", "Target", "Other",
    "Amazon", "Bars", "Drugstore", "Flights", "Gas", "Groceries", "Restaurant", "Target", "Other"
)
reward_amount <- c(
    0.01, 0.01, 0.01, 0.01, 0.03, 0.06, 0.01, 0.01, 0.01,
    0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.04, 0.01, 0.01,
    0.01, 0.03, 0.01, 0.01, 0.01, 0.01, 0.03, 0.01, 0.01,
    0.05, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01,
    NA, NA, NA, NA, NA, NA, NA, NA, NA
)

reward_category_table <- data.frame(
    reward_id = reward_id,
    card_id = card_id,
    category_name = category_name,
    reward_amount = reward_amount,
    row.names = NULL,
    check.rows = FALSE,
    check.names = TRUE,
    stringsAsFactors = default.stringsAsFactors()
)

dbWriteTable(cc_rewards_db, "reward_categories", reward_category_table, overwrite = TRUE)

# Initial Load of Stores Table
store_id <- c(
    1, 2, 3, 4, 5, 6, 7, 8, 9
)
reward_category_id <- c(
    1, 2, 3, 4, 5, 6, 6, 7, 8
)
store_name <- c(
    "Amazon", "Bars", "CVS Pharmacy", "Flights", "Gas",
    "Kroger", "Meijer", "Restaurant", "Target"
)
store_logo <- c(
    "Images/store_logos/amazon.png",
    "Images/store_logos/bar.png",
    "Images/store_logos/cvs.jpg",
    "Images/store_logos/flight.png",
    "Images/store_logos/gas.png",
    "Images/store_logos/kroger.png",
    "Images/store_logos/meijer.png",
    "Images/store_logos/restaurant.png",
    "Images/store_logos/target.png"
)

stores_table <- data.frame(
    store_id = store_id,
    reward_category_id = reward_category_id,
    store_name = store_name,
    store_logo = store_logo,
    row.names = NULL,
    check.rows = FALSE,
    check.names = TRUE,
    stringsAsFactors = default.stringsAsFactors()
)

dbWriteTable(cc_rewards_db, "stores", stores_table, overwrite = TRUE)

# Test Queries
dbGetQuery(cc_rewards_db, "SELECT * FROM credit_card_table")
dbGetQuery(cc_rewards_db, "SELECT image_path from credit_card_table where card_id = 1")[[1]]

# Test Card Query
dbGetQuery(cc_rewards_db, "SELECT * FROM credit_card_table card left join reward_category_table reward on card.card_id = reward.card_id left join stores_table stores on reward.reward_id = stores.store_id")

# Close database connection
dbDisconnect(cc_rewards_db)