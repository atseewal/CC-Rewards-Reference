library(DBI)

# Connect to Database (or create if not already created)
cc_rewards_db <- dbConnect(RSQLite::SQLite(), "cc_rewards_db.sqlite")

# Initial Load of Credit Cards
card_id <- c(1, 2, 3, 4, 5)
card_name <- c("American Express Preferred Cash Back", "American Express Gold Card", "Barclays View", "Chase Amazon Prime", "Target Store Card")
image_path <- c("Images\\credit_cards\\blue-cash-preferred.webp", "Images/credit_cards/amex-gold-card.avif", "Images\\credit_cards\\barclays-view.webp", "Images\\credit_cards\\amazon-prime-rewards.png", "Images\\credit_cards\\target.webp")

credit_card_table <- data.frame(card_id = card_id, card_name = card_name, image_path = image_path, row.names = NULL)

dbWriteTable(cc_rewards_db, "credit_card_table", credit_card_table, overwrite = TRUE)

# Initial Load of Reward Categories
reward_id <- c(1, 2, 3)
card_id <- c(1, 1, 1)
category_name <- c("Groceries", "Other", "Bars")
reward_amount <- c(0.06, 0.01, 0.01)

reward_category_table <- data.frame(reward_id = reward_id, card_id = card_id, category_name = category_name, reward_amount = reward_amount, row.names = NULL, check.rows = FALSE, check.names = TRUE, stringsAsFactors = default.stringsAsFactors())

dbWriteTable(cc_rewards_db, "reward_categories", reward_category_table, overwrite = TRUE)

# Initial Load of Stores Table
store_id <- c()
reward_category_id <- c()
store_name <- c()
store_logo <- c()

stores_table <- data.frame(store_id = c(), reward_id = c(), store_name = c(), store_logo = c(), row.names = NULL, check.rows = FALSE, check.names = TRUE, stringsAsFactors = default.stringsAsFactors())





# Run query to get data
dbGetQuery(cc_rewards_db, "SELECT * FROM credit_card_table")
dbGetQuery(cc_rewards_db, "SELECT image_path from credit_card_table where card_id = 1")[[1]]

# Close database connection
dbDisconnect(cc_rewards_db)