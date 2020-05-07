# Cat-breeds-quiz
Guess cat breed by it's photo, learn about different cat breeds and make the highest score

Application uses https://docs.thecatapi.com/ database to get cat breeds info.

Firstly, the app sends request to https://api.thecatapi.com/v1/breeds to get breeds ids and names. Secondly, the app sends request to https://api.thecatapi.com/v1/images/search?breed_ids={BREED_ID} to get full info and image of each cat breed. 

App preview:
![](app-preview.gif)
