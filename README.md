# CC-Rewards-Reference
UI application for creating credit card reward references

## Background

This project is a UI that can be used to generate up to date reference cards to maximize credit card rewards. By updating the tables, a card can be generated that will assign stores and purchase categories to different credit cards. With the reference, you will always be able to use the card with the highest reward category for your current purchase

## Front End

The front end is a Shiny application. This was chosen because they look good and are easy to develop with useful features out of the box like interactive buttons, popup's, and notifications.

The end goal is to dockerize the front end and deploy it onto a personal server, where it will be easy to access it to generate a new reference card and update in the future through GitHub and docker.

### Generate page

<!--- TODO ---> Will be added later...

### Edit tables page

<!--- TODO ---> Will be added later...

## Back End

The back end is done with R. The DBI package makes it easy to interface with the sqlite backend. The magick package is used for image manipulation, just like in my [Bernie sits Shiny application](https://github.com/atseewal/Bernie-Sits-Shiny/tree/main).

## Data model

The data is stored in a *sqlite* file. This is for simplicity. The database consists of just a few tables and is only edited by a single person at a time. Each table contains normalized data with primary and foreign keys. Each table contains data for a different subject, as described below.

### The data model

| Table Name | Description |
|-------|-|
| CREDIT_CARD_TABLE | This table describes the credit cards that have been entered into the system and where their images are located. |
| REWARDS_CATEGORIES_TABLE | This table describes the different reward categories. Each reward category is mapped to a single credit card ID on this table. **This is the table to update when reward categories change.** |
| STORES_TABLE | This table contains different stores. Each store is mapped to a reward category ID. This defines what the store is categorized under, and will be rarely updated. This table also contains generic "stores" like restaurants and gas stations. The logo image for each store or category is also stored in this table. |