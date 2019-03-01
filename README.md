セルオートマトンシェーダー
=======

## 使い方

シェーダーを設定したマテリアルを適用したQuadをCameraでRenderTextureに映し、そのRenderTextureをマテリアルのData textureに設定することでセルオートマトンが動きます．

2DCAnormalはQuadが常に表示されるのに対して2DCAhiddenはQuadの中心から0.001m以内のCameraにのみQuadが表示されます．

詳しくはDemo.unityを参照してください．

## パラメータ

* Data texture - RenderTextureを設定してください．
* Initial state - Randomizeのチェックが外れている場合にこのテクスチャで初期化されます．
* Width, Height - マス目の数です．RenderTextureのサイズと一致させてください．
* Interval - 設定した時間（秒）ごとに更新されます．
* Repeat Steps - 設定したステップ数ごとにリセットされます．0に設定すると永久にリセットされません．
* Randomize - チェックを入れるとリセット時にランダムで初期化されます．
* Density - ランダムで初期化する際の密度です．
* Birth,Survive - セルオートマトンのルールを設定します．初期状態ではConway's Game of Lifeのルール（B3/S34）が設定されています．

## ライセンス等
* レポジトリ内のソースコード等はMITライセンスに基づいて配布されます．LICENCEファイルの改変はできません．
* レポジトリ管理者 みきしぃ はレポジトリ内のファイルを使用したことで発生する一切の損害の責任を負わないものとします
* 上記が遵守される限り本ソースコード等を使用して作成した成果物は自由に公開・販売・再配布等が可能となります．
