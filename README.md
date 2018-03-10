## Dynamic Web Development Spring 2018 - Final Project
[Link to the project video](https://vimeo.com/259415)

### Overview
I made a game in the final project of this course, I used an iOS app as a game controller to and play a web-based game. I used [websocket](https://github.com/websockets/ws) to transport data from the phone to server, and then to the front-end.

### Process
This project can be broken down to three parts:

#### 1. The Asteroid Game
I used [p5.js](https://p5js.org/) as the framework to develop the backbone of the Asteroid game. In fact, there are lots of code references of this classic, iconic, and nostalgic arcade game. The one I followed is Daniel Shiffman's [coding chanllenge](https://youtu.be/hacZU523FyM) on YouTube to develop the structure of this game. 

#### 2. iOS game controller
On the iOS side, I uitilized the reference from Mobile Lab, which is an app design and development class in ITP. [The reference](https://github.com/mobilelabclass/mobile-lab-websocket-kit) used [CocoaPods](https://cocoapods.org/) as the dependency manager, which allows Swift to easily access the WebSocket. On the interface design side, I tried to use GameBoy interface as first, but it's was not that easy to play with since the the screen on the phone is flat, whereas the buttons of GameBoy are tangible. So I mapped the behavior of the spaceship to design another UI.
Here's the final UI:
![alt text](https://i.imgur.com/mDSfNtW.png "Logo Title Text 1")


#### 3. WebSocket
I used [ws](https://github.com/websockets/ws) to deal with the command from the phone.

### To ifinity + Beyond
Make a multi-player Asteroids!
