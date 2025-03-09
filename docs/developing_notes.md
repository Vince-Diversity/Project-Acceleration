# Developing notes

Just some notes of obscure problems encountered during development
* To disable an Area2D, setting its monitororable property to false does not work. The player still sees the Area2D, for example, when Thing instances have their state switched to static state. And it only happens for one frame. And it doesn't seem to matter how many idle frames are skipped either... What works is setting the CollisionShape2D of the Area2D to disabled.
* With Dialogue Manager v.3.4.0, optional responses can't be hidden from the player. They're just not selectable. That is fine for now. A bad alternative is to use match statements and copying every previous response in every new case. But that won't work because visiting worlds is eventually going to be non-linear.