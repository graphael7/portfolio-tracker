# Portfolio Tracker API

Welcome to the public interface for Portfolio Tracker.

You can use the following routes to get data from our server:

* GET `portfolio-tracker-backend.herokuapp.com/users/{user-id}/portfolio` -- Returns a JSON object that contains the up-to-the-second values of the stocks in a user's portfolio, as well as overall performance of the portfolio.

* GET `portfolio-tracker-backend.herokuapp.com/users/{user-id}/portfolio/history` -- Returns a JSON object that contains the performance history of a user's portfolio by day, for each day since the user's first buy.

* GET `portfolio-tracker-backend.herokuapp.com/stocks/{stock-id}` - Returns a JSON object of a stock's current performance, as well as its historical performance.
