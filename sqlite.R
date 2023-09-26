library(DBI)

# Connect to Database (or create if not already created)
cc_rewards_db <- dbConnect(RSQLite::SQLite(), "cc_rewards_db.sqlite")

# Initial Load of Credit Cards
card_id = c(1, 2)
card_name = c("American Express Preferred Cash Back", "American Express Gold Card")
image_path = c("Images\\credit_cards\\blue-cash-preferred.webp", "Images/credit_cards/amex-gold-card.avif")

credit_card_table <- data.frame(card_id = card_id, card_name = card_name, image_path = image_path, row.names = NULL)

dbWriteTable(cc_rewards_db, "credit_card_table", credit_card_table, overwrite = TRUE)



reward_category_table <- data.frame(reward_id = c(), card_id = c(), category_name = c(), row.names = NULL, check.rows = FALSE, check.names = TRUE, stringsAsFactors = default.stringsAsFactors())
stores_table <- data.frame(store_id = c(), reward_id = c(), store_name = c(), store_logo = c(), row.names = NULL, check.rows = FALSE, check.names = TRUE, stringsAsFactors = default.stringsAsFactors())





# Run query to get data
dbGetQuery(cc_rewards_db, 'SELECT * FROM credit_card_table')
dbGetQuery(cc_rewards_db, 'SELECT image_path from credit_card_table where card_id = 1')[[1]]

# Close database connection
dbDisconnect(cc_rewards_db)