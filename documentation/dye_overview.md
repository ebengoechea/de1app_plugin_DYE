# Describe Your Espresso Overview

Describe Your Espresso (DYE) is an open-source third-party extension/plugin for the [Decent DE1 application](https://github.com/decentespresso/de1app), developed by Enrique Bengoechea.

 ![image info](./pictures/image.png)

## History

DYE started in 2020 as an improved way of logging additional coffee shots metadata that the DE1 app didn’t really handle. The main DE1 app and the skins available at the time only exposed data directly handled by the machine hardware (pressures, flows, temperatures, etc.), but barely considered any additional information that, for the user, can be equally (or more!) relevant for espresso making, such as beans, grinder, or dose/yield ratio. The Insight skin had a page for almost the same data as DYE includes still today (as of 2024). It was the base of the first DYE version, but it was not very accessible and quite limited in scope.

At the time, the main app didn’t even support plugins, so DYE started as a [DSx skin plugin](https://github.com/ebengoechea/dye_de1app_dsx_plugin). Only later, when Johanna introduced extensions in the main app, DYE became a base app plugin. Development of DYE required several new technical capabilities that the base app didn’t provide, such as a shot history SQL database, a declarative metadata dictionary, more powerful GUI elements, or improved integration with Miha Rekar’s Visualizer cloud service. While initially included inside DYE, those were with time split off into its own components: the [Shot DataBase (SDB) plugin](https://github.com/ebengoechea/de1app_plugin_SDB), the [DUI](https://github.com/decentespresso/de1app/blob/main/documentation/decent_user_interface.md) and [metadata](https://github.com/decentespresso/de1app/blob/main/de1plus/metadata.tcl) packages that are now part of the base app, and parts of what now is the [Visualizer upload](https://github.com/decentespresso/de1app/tree/main/de1plus/plugins/visualizer_upload) plugin (maintained by Johanna).

As a third-party optional extension, DYE has been a tool for new ideas and ways of interacting with the DE1. New unexpected venues has been explored stemming both from my own interests and from users’ suggestions, creating a tool that in some ways is quite different from how it started. In that sense, DYE now offers capabilities that go well beyond “mere data logging”, such as shot history management, beans-based dial-in workflow, or profile tools.

 During most part of 2022 and 2023 DYE development halted. The publication of Damian’s new [DSx2 skin](https://github.com/Damian-AU/DSx2) incentivized me to come back and try new ideas that I had had in mind for a while, such as Favorites and Source shots, and that have triggered the desire for a redesign.

## Base concept

Typing data in a tablet screen on top of your espresso machine is… not that comfortable. Most of us bother to do it not just for the data logging, but because having that data at hand is extremely useful for dialling-in future shots. Either the immediately forthcoming shots, or any shots in the future that happen to use the same beans, or the same profile, or the same grinder.

In the beginning, DYE focused merely on facilitating the data entry process. But, with time, it became more and more a power workflow tool around shots, beans, and dialling-in. Acknowledging this should be at the core of its evolution.

DYE aspires to erase the boundaries between data that is handled by the hardware (pressure, flow, or temperature) and data that is outside the machine (beans, dose and yield, grinder, extraction or people). For the user, all can be equally relevant for preparing espresso, and, unlike most skins historically, DYE tries to present them all at the same level.


## Workflow and dialling-in: The propagation mechanism

At the core of DYE is the propagation mechanism. This is the virtual equivalent of iterative dialling-in. Whenever changing beans (or, to a lesser extent, profile or grinder, or some other parameter) you make an initial guess as to what the best profile, ratio or grinder setting may be. Espresso is prepared, tasted, and small iterative adjustments are made on each subsequent shot to improve it. Often the subsequent shot with the same beans (and/or grinder, and/or profile, etc.) is also the next shot in time. But it also happens that it is several shots, days, or even months away. DYE is there to facilitate retrieving all the data you generated for that last shot with he same beans (and/or blah blah blah) into the environment and be able to replicate it perfectly, or modify what didn’t work that well.

It is this aspect of DYE that was totally neglected in the base app when DYE development started. Despite having a fancy machine and tablet, lots of data, and saving all shots made, the base app didn’t provide any way whatsoever to access, analyze or use that historical data.

The initial versions of DYE only propagated data from one shot to the immediate next. This data propagates even after making the shot. If you modify the last shot in retrospective, those changes auto-propagate to the next shot. At least, until you modify the next shot definition manually, at that point the propagation from last-to-next will stop (whether this has happened is reflected in the UI by a “*” on the Next shot description, and by a descriptive subtitle in the Last and Next DYE pages).

This mechanism works well if you consume one bag of beans after another. But what if you have several bags open, and frequently swap beans? Or if you get a new batch of the same type of beans you already used in the past, with a new roaster date? For these cases DYE provides 2 functions, accessible from the “Edit data…” button pop-up menu:

  * **A “push” mechanism**: navigate to any past shot, then launch “Copy to Next shot....” to copy/propagate all or part of its data to the Next shot definition.
  * **A “pull” mechanism**: navigate to the Next shot, then launch “Read from selected shot…” to open a shot selection dialog and pull all or part of its data to the Next shot.
 
The user can select  which data to copy from the past to the Next shot using the checkboxes on top of the “Edit data…” dialog.

While powerful, these two functions became tedious to use when switching beans often. To tackle this, DYE recently introduced the “Recent Favorites” (only available with the DSx2 skin at the moment). The nth favorite shows the last nth beans (or beans+profile+grinder+workflow, this combination being definable by each user ) used, and selecting it propagates to the Next shot all or part of the parameters of the last shot that was made with those beans. It also flags the original shot as the “source” shot of the next shot, and shows its graph on the DSx2 skin home page. So that everything in the environment works as it that original shot was exactly the latest shot just made with the DE1. The list of “Recent Favorites” updates automatically when a new espresso is made, and is shown on the home page. Thus, this feature allows one-tap instant update of the environment to all the exact parameters you used when you last made espresso with the beans that you’re just going to use. The user can also define exactly what data should be copied when the favorite is loaded.

A new dialog for beans and grinder selection has recently been introduced in DYE for DSx2 that also allows total or partial propagation: when selecting beans the user can choose to propagate the last shot made with those beans, and when selecting grinder the user can choose to fill the grinder setting with the last value used with the same beans (if available, otherwise whatever the last setting was).

### Shot comparison for dialling-in

One of the most powerful helpers for dialling-in beans is to know exactly what parameters have been changed from shot to shot. This is something that DYE currently facilitates but quite more can be done, and this should be one focus of future developments.

The easiest way to allow this is to show the descriptions of both the next and the last or source shot on parallel so they can be compared manually. This is done on both DSx and DSx2 skins home pages, but not on other skins, which only integrate DYE with a launch button. This is in fact the main reason why DYE is so much more useful under DSx/DSx2 than under other skins.

One key part of shot parameters that is not directly managed by DYE is the profile. Apart from changing the profile, making minor modifications to a profile for a given shot is a part of the dialling-in process, and, in the default DE1 app, these changes are easily lost, because they can be saved or not, and there’s no way to retrieve what was changed for a given shot. That’s why DYE introduced its own Profile Viewer dialog, which shows a novel text description of any profile (either profiles saved to disk, or the actual profile specifically modified on a given shot) and highlights its differences with any other profile.

A “comparison mode” that explicitly shows all the differences between the next and the source shot has always been a desired feature for DYE but has not been implemented yet (except for profiles). In an ideal world, this mode should also show a compared graph of the shots, and allow changing the main dialling-in parameters on the spot.


Workflow adaptations

 

## Metadata

DYE only manages a small handful of shot metadata, with barely any change since its creation. Most of that data was already available for description in the base app and is considered just a basic set, but much more is possible. A detailed analysis of additional fields was carried out in Diaspora, ending up on [this proposal](https://3.basecamp.com/3671212/buckets/7351439/messages/3316379592#__recording_3804933033), but the new fields haven’t found its way to DYE yet, the main problem being the software UI limitations, which make it a challenge to incorporate new data for those users than want to log it, but without getting in the way for those also many users that don’t want to. But a DYE redesign should carefully considered how this could be achieved. A prototype covering this was proposed in Diaspora years ago ([DYE v3 RFC](https://3.basecamp.com/3671212/buckets/7351439/messages/3777997470)), but I wasn’t convinced so it wasn’t further developed (but other parts of that work, such as textual representations of profiles and shots, did get into DYE). A preliminary prototype for a different redesign is presented below.

A critical finding of user feedback during these years is that the metadata each user is interested in varies wildly. For example, some users don’t have a refractometer and couldn’t care less about TDS and EY, whereas others always fill it but ignore the “People” section, and so on. I find that some level of user customization of the main DYE page to accommodate this variation would be much welcomed. Both the DYE v3 RFC and the recent prototype took this into account.

 
(full shot view, inc. profile, source shot, graph)

 

## Shot history management

 

 

 

 

 

## Profile tools

 

 

 

 

## 2024 Redesign:

 

## Consistency (pages design at very different moments)

Improved & consistent navigation 

## Full shot view

## Improved data entry

##Customization


## New metadata


## Dialling-in workflow

 

