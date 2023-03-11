# iPayLocator-iOS

### How to run

```Swift
> cd iPayLocator-iOS
> pod install // (네이버맵 framework)
> open iPayLocator-iOS.xcworkspace
```
### Contents

- [App Apperance](https://github.com/alex99091/iPayLocator-iOS#app-apperance)
- [앱 개요](https://github.com/alex99091/iPayLocator-iOS#앱-개요)
- [네이버 맵 API 사용법?](https://github.com/alex99091/iPayLocator-iOS#네이버-맵-API-사용법??)


## App Apperance

<table>
<tr>
<td>
<img src="https://user-images.githubusercontent.com/111719007/224352104-1522c40c-9bcf-4c87-b565-8b5eb53be5b1.gif" width="230" height="500"/>
</td>
<td>
<img src="https://user-images.githubusercontent.com/111719007/224352135-d34baf1d-71ab-4c2c-8a69-4a7b518bbd90.gif" width="230" height="500"/>
</td>
<td>
</table>

### 앱 개요

&nbsp; 이 샘플 앱은 [네이버 개발자 API](https://developers.naver.com/main/)를 사용하여 `애플페이` 출시 이후, 
  
애플 `가맹점` `리스트`를 보여주기 위한 앱입니다. 현재 `위치 정보`는 CU/GS25/세븐일레븐의 편의점 리스트로 보여줍니다.

해당 프로젝트는 `UIKit / Storyboard` 코드 구현, 애플페이 정보를 나타낼수 있는 홈뷰등을 포함하고 있습니다.

### 네이버 맵 API 사용법??

[네이버 개발자 계정](https://developers.naver.com/main/) 등록 후, [네이버맵 라이브러리](https://github.com/navermaps/ios-map-sdk)의 링크에서 API를 사용하기 위해서는 git-lfs와 CoCoaPods가 필요하기 때문에 OS 사양에 맞추어 brew install git-lfs를 사용하여 git-lfs 설치, pod를 사용하여 cocoapods를 설치하였습니다.

네이버 맵 API는 자체적인 검색 기능을 지원하지 않기 때문에, [네이버 지역 검색](https://developers.naver.com/docs/serviceapi/search/local/local.md) API를 같이 사용했습니다.

1. `CLLocation`을 통한 나의 위치와 경도 확인하기

2. `reverseGeocoding`을 사용하여 나의 위치, 경도를 통하여 주소 얻기

3. `지역검색 API`에 적용하여 편의점(CU, GS25, 세븐일레븐)의 검색결과 받기

위의 1,2,3 순서대로 진행하였습니다.

네이버 지역검색 결과로 받은 `좌표`의 값은 `KATECH 좌표계`의 값이라 위도,경도로 `변환`이 필요합니다.

```Swift
// NMGTM128을 사용 -> KATECH(x,y) -> CLLocation2DCoordinates(lat, lng)
let convertKATECH = `NMGTm128`.init(x: x, y: y)
let convertedLatLng = convertKATECH.toLatLng()
let dataPoint = NMGPoint.init(x: convertedLatLng.lat, y: convertedLatLng.lng)
```

데이터 포인트와 현재위치의 거리 및 마커로 맵에 등록하는 코드 예시입니다.
```Swift
// 거리계산하기
let dataPoint = NMGPoint.init(x: convertedLatLng.lat, y: convertedLatLng.lng)
let currentPoint = NMGPoint.init(x: self.currentCoordinate["lat"]!, y: self.currentCoordinate["lng"]!)
let distance = dataPoint.distance(to: currentPoint)

// 데이터 Dictionary에 값을 업데이트하기
data.updateValue(String(Int(distance)), forKey: "distance")

// 위의 결과를 셀에 넣어주기
if let distance = data["distance"] {
    cell.configureDistance(distance + "m")
}

// 마커로 등록하기
let marker = NMFMarker.init(position: convertedLatLng)
marker.mapView = naverMapView
```

&nbsp; `Katech` 좌표계의 값 -> `CLLocation2DCoordinates`의 값으로 변환하는데 좌표계의 정의까지 

구글링하며 수식을 직접 구현하였으나, 탄젠트의 값을 잘못 입력하여 수식이 계속 틀렸습니다. 

생각해보면, API 사용자들이 저와 같은 방식으로 작업을 한다면 당연히 변환값이 필요할 것이고, 

이는 당연히 `레퍼런스`를 찾아보면 있다는 것을 생각하지 못했습니다. 

하루종일 실패했던 계산을 `NMGTM128 클래스`를 사용하여 1분만에 해결 한 후, `레퍼런스`를 꼼꼼히 읽는 습관을 가져야겠습니다.

  
