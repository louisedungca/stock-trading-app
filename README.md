# [Stocker](https://stocker-twbl.onrender.com/)

Welcome to the Stocker, a stock trading app simulation for NASDAQ stocks exchange! This application allows users to simulate buying and selling stocks using the IEX API for real-time stock data.

## Features
- **User Authentication:** Users can sign up, log in, and log out securely to access their personalized accounts.
- **Real-Time Stock Data:** Integration with the IEX API and TradingView charts provides up-to-date stock information for users to make informed decisions.
- **Portfolio Management:** Users can manage their portfolio, including buying and selling stocks, tracking their investments, and viewing their portfolio's performance.
- **Transaction History:** View a detailed history of all transactions, including buy/sell actions and their corresponding timestamps.
- **Search Functionality:** Users can search for stocks by ticker symbol or company name to quickly find the stocks they're interested in.

## Dependencies / Gems
- **Tailwind CSS:** Frontend framework for responsive design and styling.
- **PostgreSQL:** Database management system for storing user information and transaction history.
- **Devise:** Flexible authentication solution for Rails.
  - **Devise Invitable:** Adds support for sending invitations by email.
  - **Devise UID:** Unique identifier support for Devise.
- **IEX Ruby Client:** Integration for accessing real-time stock data.
- **Rspec:** Testing framework for Rails applications.
- **Annotate:** Automatically adds schema information to models.
- **Letter Opener:** Preview email in the browser instead of sending it.
- **Pagy:** Pagination for Rails applications.

## User Stories:
### Admin 
- [x] User Story #1: As an Admin, I want to create a new trader to manually add them to the app 
- [x] User Story #2: As an Admin, I want to edit a specific trader to update his/her details 
- [x] User Story #3: As an Admin, I want to view a specific trader to show his/her details 
- [x] User Story #4: As an Admin, I want to see all the trader that registered in the app so I can track all the traders 
- [x] User Story #5: As an Admin, I want to have a page for pending trader sign up to easily check if there's a new trader sign up 
- [x] User Story #6: As an Admin, I want to approve a trader sign up so that he/she can start adding stocks
- [x] User Story #7: As an Admin, I want to see all the transactions so that I can monitor the transaction flow of the app

### Trader
- [x] User Story #1: As a Trader, I want to create an account to buy and sell stocks
- [x] User Story #2: As a Trader, I want to log in my credentials so that I can access my account on the app
- [x] User Story #3: As a Trader, I want to receive an email to confirm my pending Account signup
- [x] User Story #4: As a Trader, I want to receive an approval Trader Account email to notify me once my account has been approved
- [x] User Story #5: As a Trader, I want to buy a stock to add to my investment(Trader signup should be approved)
- [x] User Story #6: As a Trader, I want to have a My Portfolio page to see all my stocks
- [x] User Story #7: As a Trader, I want to have a Transaction page to see and monitor all the transactions made by buying and selling stocks
- [x] User Story #8: As a Trader, I want to sell my stocks to gain money.


## Setup
1. Create an account on [IEX Cloud](https://iexcloud.io/) and get a publishable token from the IEX cloud console.

2. Fork and clone this repository.
```bash
$ git clone git@github.com:louisedungca/stock-trading-app.git
$ bundle install
$ bin/rails db:prepare
```
Note: If NoMethodError is encountered and looking for IEX_API_PUBLISHABLE_TOKEN, generate a new master.key and add your credentials:
```bash
$ rails credentials:edit
```
```bash
# tmp/some_timestamp_and_id-credentials.yml

iex:
  IEX_API_PUBLISHABLE_TOKEN: enter_your_publishable_token
  IEX_API_SECRET_TOKEN: enter_your_secret_token

outlook_smtp:
  email: enter_valid_email_for_mailers
  password: enter_valid_email_password

# aws:
#   access_key_id: some_generated_id
#   secret_access_key: some_generated_key

# Used as the base secret for all MessageVerifiers in Rails, including the one protecting cookies.
secret_key_base: generated_secret_key
```

3. Start the application:
```bash
$ ./bin/dev
```

## Contributing
Contributions are welcome! Please fork and clone this repository, create a new branch for your awesome feature/contribution, and submit a pull request with your changes. Make sure to follow the existing code style and write tests for any new functionality.
