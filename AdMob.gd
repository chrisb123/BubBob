extends Node

signal LoadScreen_Finished

var admob = null
var isReal = false
var isTop = true
var adBannerId = "ca-app-pub-3940256099942544/6300978111" # [Replace with your Ad Unit ID and delete this message.]
var adInterstitialId = "ca-app-pub-3940256099942544/1033173712" # [Replace with your Ad Unit ID and delete this message.]
var adRewardedId = "ca-app-pub-3940256099942544/5224354917" # [There is no testing option for rewarded videos, so you can use this id for testing]

# Ad States

var inter_ready = false
var banner_ready = false

# Debug Vars

var BannerStartTime
var BannerEndTime
var InterStartTime
var InterEndTime

func _ready():
	if(Engine.has_singleton("AdMob")):
		admob = Engine.get_singleton("AdMob")
		#admob.init(isReal, get_instance_id())
		#loadBanner()
		#loadInterstitial()
		#loadRewardedVideo()
	
	get_tree().connect("screen_resized", self, "onResize")
# Loaders

func _initialize(isReal):
	admob.init(isReal, get_instance_id())
	if isReal == true:
		adBannerId = "ca-app-pub-3314225270255384/8529490625"	# change to Admob Account details
		adInterstitialId = "ca-app-pub-3314225270255384/9428527376" # change to Admob Account details
		#adRewardedId = "ca-app-pub-3940256099942544/5224354917" # change to Admob Account details
	else:
		adBannerId = "ca-app-pub-3940256099942544/6300978111"	# Test Ad ID
		adInterstitialId = "ca-app-pub-3940256099942544/1033173712" # Test Ad ID
		#adRewardedId = "ca-app-pub-3940256099942544/5224354917" # Test Ad ID
	loadBanner()
	loadInterstitial()
	#loadRewardedVideo()

func loadBanner():
	if admob != null:
		admob.loadBanner(adBannerId, isTop)
	if OS.is_debug_build():
		get_node("/root/Main/Debug")._String("AdMob Banner Loading")
		BannerStartTime = OS.get_unix_time()
	#admob.showBanner() #tesing only, should be called in program proper
		
func loadInterstitial():
	if admob != null:
		inter_ready = false
		admob.loadInterstitial(adInterstitialId)
		$Inter_Timeout.start() #Stopped once ad loaded (_on_interstitial_loaded())
	if OS.is_debug_build():
		InterStartTime = OS.get_unix_time()
		get_node("/root/Main/Debug")._String("AdMob Inter Loading")
		
#func loadRewardedVideo():
#	if admob != null:
#		admob.loadRewardedVideo(adRewardedId)

# Events

func _hide_banner():
	if admob != null:
		admob.hideBanner()

#func _on_BtnInterstitial_pressed():
#	if admob != null:
#		admob.showInterstitial()
		
#func _on_BtnRewardedVideo_pressed():
#	if admob != null:
#		admob.showRewardedVideo()

func _on_admob_network_error():
	if OS.is_debug_build():
		get_node("/root/Main/Debug")._String("AdMob Network Error")

func _on_admob_ad_loaded():
	if OS.is_debug_build():
		BannerEndTime = OS.get_unix_time()
		get_node("/root/Main/Debug")._String(str("Admob Banner Loaded ", BannerEndTime - BannerStartTime, "s"))
		BannerStartTime = OS.get_unix_time()

func _on_interstitial_not_loaded():
	if OS.is_debug_build():
		get_node("/root/Main/Debug")._String("AdMob Inter Load Error")
	yield(get_tree().create_timer(5),"timeout")
	loadInterstitial()

func _on_interstitial_loaded():
	if admob != null:
		inter_ready = true
		$Inter_Timeout.stop()
	if OS.is_debug_build():
		InterEndTime = OS.get_unix_time()
		get_node("/root/Main/Debug")._String(str("Admob Inter Loaded ", InterEndTime - InterStartTime, "s"))

func _show_interstital():
	admob.showInterstitial()
	if OS.is_debug_build():
		get_node("/root/Main/Debug")._String("AdMob Inter Shown")

func _on_interstitial_close():
	if OS.is_debug_build():
		get_node("/root/Main/Debug")._String("Admob Inter Closed")
		get_node("/root/Main/Debug")._String("AdMob Inter Loading")
		InterStartTime = OS.get_unix_time()
	emit_signal("LoadScreen_Finished")
	#loadInterstitial() #Closing internally automatically starts loadinterstitional()

#func _on_rewarded_video_ad_loaded():
#	print("Rewarded loaded success")
#	get_node("CanvasLayer/BtnRewardedVideo").set_disabled(false)
	
#func _on_rewarded_video_ad_closed():
#	print("Rewarded closed")
#	get_node("CanvasLayer/BtnRewardedVideo").set_disabled(true)
#	loadRewardedVideo()
	
#func _on_rewarded(currency, amount):
#	print("Reward: " + currency + ", " + str(amount))
#	get_node("CanvasLayer/LblRewarded").set_text("Reward: " + currency + ", " + str(amount))

# Resize

func onResize():
	if admob != null:
		admob.resize()

func _on_Inter_Timeout_timeout():
	get_node("/root/Main/Debug")._String("AdMob Inter Timeout (reloading)")
	loadInterstitial()
