I represent one worker with my worker start. In general I have my own Mongo object and use it in an infinite loop. I try to sleep as long as possible in case no work is scheduled. I use the ShortMessageDatabase and ShortMessageOMDatabase to do most of my work.