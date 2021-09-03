# Gympass

This app was built using Elixir. Make sure that you have it installed on your machine ;)

## Running tests
On terminal, run:
```elixir
$ mix test
```
## Running the application
I decided to use escript to run the application from the command line. There are probably better ways to do that with Elixir, but the lack of production code with it led me to this approach.

### Compiling
```bash
$ mix escript.build
```

### Running
```bash
./gympass --file <file_name>
```
*(There is a file named `race_log` in the root folder, you can use it)*

You should get the output like:
```

🏁 Gympass Kart Race 🏎 🏎 🏎

Position  Pilot                  Laps    Time           Best Lap       Avg Lap Speed  After 1st              
1         038 – F.MASSA          4       00:04:11.578   00:01:03.170   44.245         00:00:00.0             
2         002 – K.RAIKKONEN      4       00:04:15.153   00:01:03.076   43.627         00:00:03.575           
3         033 – R.BARRICHELLO    4       00:04:16.080   00:01:04.002   43.467         00:00:04.502           
4         023 – M.WEBBER         4       00:04:17.722   00:01:04.216   43.191         00:00:06.144           
5         015 – F.ALONSO         4       00:04:54.221   00:01:07.011   38.066         00:00:42.643           
6         011 – S.VETTEL         3       00:06:27.276   00:01:18.097   25.745         00:02:15.698           


⏱ The best lap
Pilot                  Time           
002 – K.RAIKKONEN      00:01:03.076
```
or, in case of empty files:
```
Error: empty_log
```

## Decisions and next steps
I am not proficient in Elixir, but it is something I've been looking into and am very excited about. It's syntax makes functional programming easy to learn and use.

I've decided to pass all the data into a stream of modifications, abusing on data manipulation with map and reduce because I underrstand thast situations like the one proposed by the exercise is more about transforming data than recognizing entities, classes, models. That is also the reason why I didn't choose an object oriented language such as Ruby or C#.

As for Elixir, I didn't use OTP, for two reasons. The first one is: I don't want to impress you with things I have never worked with and am not proficient. Elixir really shines when using OTP, but I just wanted to solve this by using a simple and plain FP approach. Second I don't think the problem demanded.

Could I use it? Sure. I can see a scenario where I am parsing a log file thousands of times bigger, then I could have made each line or each chunk of lines to be processed in isolation and paralelised. If anything goes wrong with it, the process can be restarted or something like that. The magic of OTP.

I also think I could have stressed more the wrong messages scenarios. Log files with wrong formats and things like that. I have only tested scenarios with valid data.