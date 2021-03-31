# README #

# アプリ名 #
現場情報共有ツール

# 概要 #
目的の場所へのルート情報を地図ベースで登録/共有
経由地の情報をハッシュタグとして付加することで細やかなルート案内と、検索/共有を図ります。

# コンセプト #
未経験・経験浅の運輸/物流業者を応援！
現場についての蓄積された不定型の情報共有を図ります。

# バージョン #
Ruby 2.6.5 Rails 5.2.4

# 機能一覧 #
 * 利用者がチーム内で共有できる現場（場所）情報の作成/参照/編集/削除
 * 現場情報の住所から地図を表示 
 * 現場情報にラベルを紐付けて絞り込み検索 
 * 現場情報にハッシュタグを紐付けて絞り込み検索
 * Google KMLファイル読み込み、ハッシュタグと地図の自動生成 

# カタログ設計 #
 * https://docs.google.com/spreadsheets/d/1sKZ-tPR601fRRa5cgoPGUt8aSxJSGSRxcbIBju0XznM/edit#gid=19502736

# テーブル定義 #
 * https://docs.google.com/spreadsheets/d/1_tLmo6-sPF0UTGntdeo0wp7cjh5ehqY1Z2LZAgPdA1U/edit#gid=0

# ER図 #

  * draw.io
    https://drive.google.com/file/d/1mWxKMG3SRWvwAZJm-iKl-LiDMzibSeNz/view?usp=sharing

  * png
    https://drive.google.com/file/d/1XCCVp_-mcReyx_rAH0BAayksdojxEm2w/view?usp=sharing

# 画面遷移図 #

  * (appで開いて下さい)
  https://drive.google.com/file/d/1F2f3SE30bvL5Um2bPeV9Z-S8sPpcfCVq/view?usp=sharing

# ワイヤーフレーム #
 * https://drive.google.com/file/d/1_7j5QH2XuDYRiseUbGtsNBDVWQpPqpoP/view?usp=sharing

# 使用予定Gem #
 * devise
 * ransack
 * careerWave

# README #

# APPNAME #
Site Information Sharing-tool

# OverView #
Map-based registration / sharing of route information to the desired location
By adding the information of the waypoints as a hashtag, detailed route guidance and search / sharing are planned.

# Concept #
Supporting inexperienced and inexperienced transportation / logistics companies!
We will share the accumulated irregular information about the site.

# Version #
Ruby 2.6.5 Rails 5.2.4

# Functions List #
  * Create / reference / edit / delete site (location) information that users can share within the team
  * Display the map from the address of the site information
  * Search by associating a label with site information
  * Search by associating hashtags with site information
  * Read Google KML file, automatically generate hashtag and map

# Catalog design #
 * https://docs.google.com/spreadsheets/d/1sKZ-tPR601fRRa5cgoPGUt8aSxJSGSRxcbIBju0XznM/edit#gid=19502736
 
# Table_Definition #
 * https://docs.google.com/spreadsheets/d/1_tLmo6-sPF0UTGntdeo0wp7cjh5ehqY1Z2LZAgPdA1U/edit#gid=0
 
# Screen transition diagram #
  * (please open with app)
    https://drive.google.com/file/d/1F2f3SE30bvL5Um2bPeV9Z-S8sPpcfCVq/view?usp=sharing
  
# Wire frame #
 * https://drive.google.com/file/d/1_7j5QH2XuDYRiseUbGtsNBDVWQpPqpoP/view?usp=sharing
 
# ER diagram #
  * (draw.io)
    https://drive.google.com/file/d/1mWxKMG3SRWvwAZJm-iKl-LiDMzibSeNz/view?usp=sharing

  * (png)
    https://drive.google.com/file/d/1XCCVp_-mcReyx_rAH0BAayksdojxEm2w/view?usp=sharing



# To be used Gem #
 * devise
 * ransack
 * careerWave
