//
//  ContentView.swift
//  MyTimer
//
//  Created by みねた on 2022/02/02.
//

import SwiftUI

struct ContentView: View {
    @State var timerHandler : Timer? //Timer型のtimerHandlerという変数
    @State var count = 0 //カウント(経過時間)の変数
    @AppStorage("timer_value") var timerValue = 10 //永続化(データを保存)する秒数設定 (初期値は10)
    @State var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("backgroundTimer")
                    .resizable()
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)
                VStack(spacing: 30.0) {
                    Text("残り\(timerValue - count)秒")
                        .font(.largeTitle)
                    HStack {
                        Button(action: {
                            startTimer()
                        }) {
                            Text("スタート")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: 140, height: 140)
                                .background(Color("startColor"))
                                .clipShape(Circle())
                        }
                        Button(action: {
                            //timerHandlerをアンラップしてunwrapedTimerHandlerに代入
                            if let unwrapedTimerHandler = timerHandler {
                                //もしタイマーが実行中だったら停止
                                if unwrapedTimerHandler.isValid == true {
                                    //タイマー停止
                                    unwrapedTimerHandler.invalidate()
                                }
                            }
                        }) {
                            Text("ストップ")
                                .font(.title)
                                .foregroundColor(Color.white)
                                .frame(width: 140, height: 140)
                                .background(Color("stopColor"))
                                .clipShape(Circle())
                        }
                    }
                }
            } // -- ZStack
            //画面が表示されるときに実行される
            .onAppear {
                //カウントの変数を初期化
                count = 0
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingView()) {
                        Text("秒数設定")
                    }
                }
            } // -- toolbar
            //状態変数showAlertがtrueになった時に実行される
            .alert(isPresented: $showAlert) {
                Alert(title: Text("終了"),
                      message: Text("タイマー終了時間です"),
                      dismissButton: .default(Text("OK")))
            }
        }// -- NavigationView
        //iPadへ対応
        .navigationViewStyle(StackNavigationViewStyle())
    } // -- body
    
    func countDownTimer() {
        //count(経過時間)に1ずつ足していく
        count += 1
        //残り時間が0以下の時、タイマーを止める
        if timerValue - count <= 0 {
            //タイマー停止
            timerHandler?.invalidate()
            //アラート表示するか否かを示すブール型の変数をtrueに書き換え
            showAlert = true
        }
    } // -- countDownTimer
    
    func startTimer() {
        //timerHandlerをアンラップしてunwrapedHandlerに代入
        if let unwrapedTimerHandler = timerHandler {
            //もしタイマーが、実行中だったらスタートしない
            if unwrapedTimerHandler.isValid == true {
                return //何も処理しない
            }
        }
        //残り時間が0以下の時、count(経過時間)を0に初期化する
        if timerValue - count <= 0 {
            //countを0に初期化する
            count = 0
        }
        //タイマーをスタート
        //TimerクラスのscheduledTimerは一定間隔で処理を実行する。
        //今回は1秒に1回作動し、経過時間を処理する[countDownTimer]が実行される
        timerHandler = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            countDownTimer()
        }
        //scheduledTimerの引数のメモ。
        //withTimeInterval => タイマーを実行させる間隔。単位は秒。
        //repeats => 繰り返しを指定。　true = 繰り返し, false = 一回のみ。
        //block(今回は省略) => タイマー実行時に呼び出されるトレイングクロージャ。
    }// -- startTimer
}// -- CountentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

