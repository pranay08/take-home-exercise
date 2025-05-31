### Summary: Include screen shots or a video of your app highlighting its features

- The app targets iOS 16 and up. It has two screens:
    1. A home screen with three modes to choose from
    2. A recipe list with three states - success, failure and empty
- See screen recording for reference.

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?

I prioritized my focus on architecture, UI/UX and testing. The reason for choosing these areas of focus are:

    1. Architecture to support scalability
    2. UI/UX for better user experience and to enable user engagement
    3. Testing to ensure code quality and reliability

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?

I spent a total of 7 hours on this project. I allocated a major chunck of this time (around 4.5 hours) to come up with architecture and writing the core functionality of the app. The core functionality includes - implementing networking layer, building the navigation stack with bare minimum UI elements, writing an async image view component with built in caching and finally connecting all components.

Then I spent one hour improving the UI/UX. I scoured the web for some image icons for empty state and error state views. I also updated the list view to show recipes in a card style layout and implemented UI to refresh the list. The list is refreshable either by pull to refresh action or by a navigation button on the top right corner of the recipes view.

Finally I spent 1.5 hours for writing unit tests. Plus an additional 15-20 minutes in writing this readme file.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?

One of the trade-offs I made is not being able to include logging or crash reporting tools in the app. This is something I would definitely include in a production ready app, apart from analytics.

### Weakest Part of the Project: What do you think is the weakest part of your project?

I think the weakest part is probably the lack of security/authentication. But such is the API, so I couldn't implement any authentication logic.

Apart from that, the error handling is minimal. I am only checking for a status code between 200 and 299 and ignoring all other error codes. This is because of my limited knowledge of the provided endpoints. We could improve upon custom error handling to provide a better user experience based on certain error codes from the API.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.

Nothing that I can think of.
