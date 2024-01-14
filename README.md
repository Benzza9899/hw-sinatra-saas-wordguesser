# WordGuesser on Rails

In a [previous assignment](https://github.com/saasbook/hw-sinatra-saas-wordguesser) you created a simple Web app that plays the Wordguesser game.

More specifically:

1. You wrote the app's code in its own class, `WordGuesserGame`, which knows nothing about being part of a Web app.

2. You used the Sinatra framework to "wrap" the game code by providing a set of RESTful actions that the player can take, with the following routes:

    * `GET  /new`-- default ("home") screen that allows player to start new game
    * `POST /create` -- actually creates the new game
    * `GET  /show` -- show current game status and let player enter a move
    * `POST /guess` -- player submits a letter guess
    * `GET  /win`   -- redirected here when `show` action detects game won
    * `GET  /lose`  -- redirected here when `show` action detects game lost

3. To maintain the state of the game between (stateless) HTTP requests, you stored a copy of the `WordGuesserGame` instance itself in the `session[]` hash provided by Sinatra, which is an abstraction for storing information in cookies passed back and forth between the app and the player's browser.

In this assignment, you'll reuse the *same* game code but "wrap" it in a simple Rails app instead of Sinatra.

## Learning Goals

Understand the differences between how Rails and Sinatra handle various aspects of constructing SaaS, including: 

* how routes are defined and mapped to actions; 
* the directory structure used by each framework;
* how an app is started and stopped; 
* how the app's behavior can be inspected by looking at logs or invoking a debugger. 

## 1. Run the App

**NOTE: You may find these [Rails guides](http://guides.rubyonrails.org/v4.2/) and the [Rails reference documentation](http://api.rubyonrails.org/v4.2.9/) helpful to have on hand.**

Like substantially all Rails apps, you can get this one running by doing these steps:

1. Clone or fork the [repo](https://github.com/saasbook/hw-rails-wordguesser)

2. Change into the app's root directory `hw-rails-wordguesser`

3. Run `bundle install --without production`

4. | Local Development                      	| Codio                                                     	|
    |----------------------------------------	|-----------------------------------------------------------	|
    | Run `rails server` to start the server 	| Run <br>`rails server -b 0.0.0.0`<br> to start the server 	|

### To view your site in Codio
Use the Preview button that says "Project Index" in the top tool bar. Click the drop down and select "Box URL" 

![.guides/img/BoxURLpreview](https://global.codio.com/content/BoxURLpreview.png)

For subsequent previews, you will not need to press the drop down -- your button should now read "Box URL".

**Q1.1.**  What is the goal of running `bundle install`?
# การติดตั้ง Bundle เป็นคำสั่งในโปรเกจต์ Ruby เป้าหมายของการรัน Bundle คือเพื่อติดตั้งเวอร์ชั่น gems ที่ต้องการ
**Q1.2.**  Why is it good practice to specify `--without production` when running  it on your development computer?
# ช่วยลดระยะเวลาในการติดตั้ง
**Q1.3.** 
(For most Rails apps you'd also have to create and seed the development database, but like the Sinatra app, this app doesn't use a database at all.)
# Sinatra app จะมีความเรียบง่ายในการทำงานมากกว่าเเละมีความง่ายในการติดตั้งและการปรับใช้ ส่วน ในแอปพลิเคชัน Ruby on Rails ใช้เพื่อเติมฐานข้อมูลด้วยข้อมูลที่กำหนดไว้ล่วงหน้า ข้อมูลนี้อาจรวมถึงบัญชีผู้ใช้เริ่มต้น ผลิตภัณฑ์ตัวอย่าง หรือบันทึกอื่น ๆ ที่จำเป็นสำหรับแอปพลิเคชันในการทำงานอย่างถูกต้อง
Play around with the game to convince yourself it works the same as the Sinatra version.

## 2. Where Things Are

Both apps have similar structure: the user triggers an action on a game via an HTTP request; a particular chunk of code is called to "handle" the request as appropriate; the `WordGuesserGame` class logic is called to handle the action; and usually, a view is rendered to show the result.  But the locations of the code corresponding to each of these tasks is slightly different between Sinatra and Rails.

**Q2.1.** Where in the Rails app directory structure is the code corresponding to the `WordGuesserGame` model?
# /workspaces/ruby-2/hw-rails-wordguesser/app/models/word_guesser_game.rb
**Q2.2.** In what file is the code that most closely corresponds to the  logic in the Sinatra apps' `app.rb` file that handles incoming user actions?
# game_controllers.rb
**Q2.3.** What class contains that code?
# class GameController
**Q2.4.** From what other class (which is part of the Rails framework) does that class inherit? 
# class ApplicationController
**Q2.5.** In what directory is the code corresponding to the Sinatra app's views (`new.erb`, `show.erb`, etc.)?  
# /workspaces/ruby-2/hw-rails-hangperson/app/views/game/new.html.erb
# /workspaces/ruby-2/hw-rails-hangperson/app/views/game/show.html.erb
**Q2.6.** The filename suffixes for these views are different in Rails than they were in the Sinatra app.  What information does the rightmost suffix of the filename  (e.g.: in `foobar.abc.xyz`, the suffix `.xyz`) tell you about the file contents?  
# ในชื่อไฟล์เช่น index.html.erb ส่วนต่อท้าย .html.erb จะให้ข้อมูลเกี่ยวกับเนื้อหาและรูปแบบของไฟล์
**Q2.7.** What information does the  other suffix tell you about what Rails is being asked to do with the file?
# รูปแบบการจัดเก็บข้อมูลของไฟล์แต่ละชนิดและเนื้อหาของข้อมูลในไฟล์
**Q2.8.** In what file is the information in the Rails app that maps routes (e.g. `GET /new`)  to controller actions?  
# Config/routes.rb
**Q2.9.** What is the role of the `:as => 'name'` option in the route declarations of `config/routes.rb`?  (Hint: look at the views.)
# คือการสร้าง route ที่มีชื่อ สามารถใช้เพื่อสร้าง URL และผู้ช่วยเหลือเส้นทางในแอปพลิเคชัน โดยจะให้ชื่อเชิงสัญลักษณ์แก่เส้นทาง ทำให้สะดวกยิ่งขึ้นและอ่านง่ายในการอ้างอิงเส้นทางนั้นตลอดทั้งโค้ด

## 3. Session

Both apps ensure that the current game is loaded from the session before any controller action occurs, and that the (possibly modified) current game is replaced in the session after each action completes.

**Q3.1.** In the Sinatra version, `before do...end` and `after do...end` blocks are used for session management.  What is the closest equivalent in this Rails app, and in what file do we find the code that does it?
# - - -
**Q3.2.** A popular serialization format for exchanging data between Web apps is [JSON](https://en.wikipedia.org/wiki/JSON).  Why wouldn't it work to use JSON instead of YAML?  (Hint: try replacing `YAML.load()` with `JSON.parse()` and `.to_yaml` with `.to_json` to do this test.  You will have to clear out your cookies associated with `localhost:3000`, or restart your browser with a new Incognito/Private Browsing window, in order to clear out the `session[]`.  Based on the error messages you get when trying to use JSON serialization, you should be able to explain why YAML serialization works in this case but JSON doesn't.)
# เหตุผลหลักที่ JSON ไม่สามารถแทนที่ YAML เป็นเพราะการจัดเก็บข้อมูลที่แตกต่างกันและรูปแบบที่กำหนดส่วนมากจะเป็น YAML

## 4. Views

**Q4.1.** In the Sinatra version, each controller action ends with either `redirect` (which as you can see becomes `redirect_to` in Rails) to redirect the player to another action, or `erb` to render a view.  Why are there no explicit calls corresponding to `erb` in the Rails version? (Hint: Based on the code in the app, can you discern the Convention-over-Configuration rule that is at work here?)
# ใน Sinatra การเรียก erb เป็นสิ่งจำเป็นในการแสดงผล เนื่องจาก Sinatra ไม่มีแบบแผนที่เข้มงวดสำหรับการดูตำแหน่งไฟล์หรือชื่อ นักพัฒนาซอฟต์แวร์ต้องระบุไฟล์เทมเพลตที่จะแสดงผล

... (18 บรรทัด)