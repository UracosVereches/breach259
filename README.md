## What's this
&nbsp;&nbsp;&nbsp;&nbsp;This repository contains the server-side reverse-engineering of NextOren 2.5.9-C #2 ( Final ), a popular old Russian Garry’s Mod Breach server that operated in 2019 and shut down in early 2020. It shut down because developers moved on from this version and completely renovated the gamemode, running first 2.6.0 version beta tests somewhere in spring 2020. Eventually it evolved into what is known as NextOren Breach 1.0.\
&nbsp;&nbsp;&nbsp;&nbsp;I reverse-engineered the 2.5.9 version that same year, starting in March, with the first beta tests running about three months later in June. At the time, I had zero Lua or any general coding skills, so the code quality is understandably shitty and beyond just sub-par. If you intend to use this - you're better off rewriting the entire gamemode, it won't be very hard.

Here are some videos from the original server:\
https://youtu.be/h4nG80PiHfo  
https://youtu.be/0vLHm4iZzPg

&nbsp;&nbsp;&nbsp;&nbsp;My reverse-engineered iteration of 2.5.9 shut down in the beginning of 2021, about half a year later, simply because this server just got way too old for a lot of people. This was especially true given that NextOren had already released a newer Breach server, version 1.0. Player count slowly faded and I had no choice but to pull the plug.\
&nbsp;&nbsp;&nbsp;&nbsp;Later with the development team I had assembled over the course of running 2.5.9, one of our members, Cyox(aka Suoh) decided to reverse-engineer the 2.6.0 beta iterations from NextOren. He extracted the neccessary content, client and shared code from the beta tests, but then gave up shortly afterward. I took over and completed a significant portion of gamemode, but slowly my motivation reduced too, since there was just so much more shit to do. Shaky took over since then and he managed to run first beta tests. after which I returned to continue developing 2.6.0 alongside him.\
&nbsp;&nbsp;&nbsp;&nbsp;In our opinion 2.6.0 was much better than the next version of it - 1.0, there was more content and that was the major reason why we decided to bring it back for the people. We gradually improved both the code and gameplay, and, surprisingly, our reverse-engineered 2.6.0 overtook the original 1.0 that was running at the time, surpassing it in player count, which resulted in a steady decline of 1.0, forcing the NextOren developers to shut it down. 

## About the code
This repository features 100% original and authentic clientside and shared code that was downloaded directly from NextOren 2.5.9 server.

It also includes some of the earliest documented advancements of the Ksaikok anticheat. It wasn’t very good back then, so you definitely shouldn’t rely on it now - it’s outdated and unreliable. Its code is cringe as hell.

This server had a bunch of gmodstore paid addons, I removed them to avoid copyright fuckery:
- bLogs for gmod admin suite
- Lootable corpses (I only left out clientside code)
- Lounge chatbox (Config files only)

## Original authors
**Ghelid**(https://steamcommunity.com/profiles/76561198019442318), a.k.a Loaskyial [Varus] SUS - code powerhouse\
**Cultist_kun**(https://steamcommunity.com/profiles/76561197987190249) - the NextOren model man  

## Repository state
This repository will NOT receive updates, there's 0 incentive for it. I also won't help you install this on your server, you're on your own.

I literally uploaded code as it was back then. With a few small changes like removing occassional n-words and f-words from the code (search big_black_hands and models/scp/juggernaut_******_varus_asshole_penis_moron_benis_anus_dick_cock_ass.mdl)

This repository is basically a relic from that era - preserved for archival, research, or nostalgia purposes.

## Workshop Content
Everything that you need can be found at lua\autorun\server\workshop.lua
