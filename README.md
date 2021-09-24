# 📝 Cloud Note (동기화 메모장)
- **팀 구성원 : Jiss(hrjy6278)**
- **프로젝트 기간 : 2021.08.30 ~ 09.17** 


- **UML**
    <details>
    <summary>UML</summary>
    <div markdown="1" style="overflow-x:auto;">       
        <img src="https://user-images.githubusercontent.com/71247008/133712464-ff6f8ad8-a5cf-46c1-95a9-6bcbdadca87e.png" style="max-width:none;">

    </div>
    </details>

## 목차
[I. 앱 동작](#i-앱-동작)<br>
[II. 요구 기능](#ii-요구-기능)<br>
[III. 이를 위한 설계](#iii-이를-위한-설계)<br>
[IV. 💫Trouble Shooting💫](#iv-trouble-shooting)<br>
 - 1. 테이블뷰에서 뷰들이 한곳에 모여있는 에러 <br>
 - 2. 테이블뷰의 Separator가 왼쪽에 끊어져 있는 에러<br>
 - 3. DateFormatter locale이 제대로 적용이 안되는 문제.<br>
 - 4. TextView의 스크롤의 시작부분이 제일 상단이 아닌, 중간쯤에 위치하는 에러 <br>
 - 5. TableView의 오토레이아웃을 주지않았는데 왜 자동으로 적용이 될까?<br>
 - 6. 오토레이아웃 경고가 계속 뜨는 에러<br>
 - 7. Split View에서 Secondary View가 계속 push 되는 에러 <br>
 - 8. 테이블 뷰에서 스와이프가 작동이 안되는 에러 <br>
 - 9. 메모의 내용 수정시, 메모리스트에 수정된 내역이 반영이 안되는 에러 <br>
 - 10. TextView의 Text가 마음대로 단어가 바뀌는 에러. <br>
 
[V. 아쉽거나 해결하지 못한 부분](#v-아쉽거나-해결하지-못한-부분)<br>
[VI. 관련 학습 내용](#vi-관련-학습-내용)<br>

<br><br> 



## I. 앱 동작
### Width - Compact 인 경우 
#### 메모 추가 화면
![아이폰 메모 추가](https://user-images.githubusercontent.com/71247008/133713797-2d00743b-143f-4dbb-a82f-baf4bf3f1cca.gif)
<br>
#### 메모 수정 화면
![아이폰 메모 수정](https://user-images.githubusercontent.com/71247008/133713783-69a9acbb-b9cb-4b57-b51f-adc29f2c7c00.gif)
<br>
#### 메모 삭제 화면
![아이폰 메모 삭제](https://user-images.githubusercontent.com/71247008/133713765-7022bc45-bef4-41d4-b0ec-1fd9b1aa7f8b.gif)
<br>
#### 테이블뷰 스와이프 액션 구현
![테이블뷰 스와이프액션](https://user-images.githubusercontent.com/71247008/133713804-c22e4590-cc18-4760-984b-2b4626bf1834.gif)
<br>

### Width - Rugular 인 경우
#### 메모 추가, 수정 화면
![아이패드 메모 작성](https://user-images.githubusercontent.com/71247008/133714160-dc1f39ce-181e-4d61-bc31-8a0d0162fcdc.gif)
<br>
#### 메모 삭제 화면
![아이패드 삭제기능](https://user-images.githubusercontent.com/71247008/133714168-d9626586-0d77-4c66-8982-2c19b06f8565.gif)
<br>
#### 액션 시트 화면
![아이패드 더보기버튼](https://user-images.githubusercontent.com/71247008/133714147-6ad9d4e3-33de-4f57-a2a4-a9968e8f79f1.gif)
<br><br>
## II. 요구 기능
#### 1.  **Size에 맞는 다양한 화면을 구현(SplitView 활용)**
#### 2.  **UI를 스토리보드를 사용하지 않고, 코드로 작성**
#### 3.  **메모의 CRUD 구현**
#### 4.  **메모의 내역을 영구저장소에 저장(NSFerchedResultsController 활용)**
#### 5.  **테이블뷰의 스와이프 액션 구현, UIAlertController의 활용**
#### 6.  **CRUD의 Unit Test 진행**
<br><br>

## III. 이를 위한 설계

### 1. CoreData 설계
![image](https://user-images.githubusercontent.com/71247008/133715679-df7069ef-cc22-4b98-8478-eb8813581f38.png)


  
<details>
<summary> Core Data 설계와 그 이유 </summary>
<div markdown="1">       


1) `CoreData Stack` 을 구현하여 코어데이터를 구성하는 객체들이 모인 `NSPersistentCloudKitContainer`를 프로퍼티로 선언 하였다. 또한
`NSPersistentStoreDescription` 프로퍼티를 선언하여 CoreData Stack을 초기화할때 이니셜라이저에서 `NSPersistentStoreDescription` 타입을 주입받을 수 있도록 설계하였다.
    - 그 이유는 코어데이터의 영구 저장소의 설정을 유연하게 처리 할 수 있도록 해당 타입의 인스턴스를 받도록 설계하였다.
    
2) `CoreData Stack`타입을 `CoreDataCloudMemo`의 프로퍼티로 선언함.
    - 각각의 모델에 맞는 `CoreData` 마다 독립적인 `CoreDataStack`을 가질 수 있게 끔 설계하였다. 사실 처음에는 `CoreDataStack`을 싱글턴 방식으로 여러군데에서 한개의 Stack 인스턴스를 참조 할 수 있게끔 설계했으나, UnitTest시에 같은 저장소를 공유하는 이유때문에 싱글턴 방식을 사용하지 않고, 코어데이터 모델이 코어데이터 스택을 소유하는 방식을 사용하게 되었다. 
    
    
    ```swift
    class CoreDataStack {
    private let persistentStoreDescription: NSPersistentStoreDescription?
    
    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: CoreDataStack.modelName)
        
    // persistentStoreDescription 속성이 nil이 아닐경우
    // NSPersistentCloudKitContainer 컨테이너에 해당 속성을 넣어주게 된다.
        if let persistentStoreDescription = persistentStoreDescription {
            container.persistentStoreDescriptions = [persistentStoreDescription]
        }
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
    return container
    }()

    }
  
    
    
    final class CoreDataCloudMemo: CoreDatable {
    // MARK: Property
    var context: NSManagedObjectContext
    private var fetchedController: NSFetchedResultsController<CloudMemo>
    // 코어데이터 스택을 소유하게 만듦
    private var coreDataStack: CoreDataStack


    ```
    - 실체화된 코어데이터 모델은 초기화 시에 `NSPersistentStoreDescription` 을 주입받아 어떤 영구저장소를 사용하게 될지 유연하게 설정 할 수 있게 되었다.
</div>
</details>

<br>

### 2. managedObject 의 CRUD 구현
<details>
<summary> managedObject 의 CRUD 설계와 이유 </summary>
<div markdown="1">       
1) 해당 CRUD 기능은 CoreData의 Model을 관리하는 타입마다 기본적으로 공통적으로 가져야 할 기능임을 인지하고, 기능들을 `CoreDatable` 프로토콜을 선언하고 프로토콜 기본구현을 적용하였다.

```swift=
protocol CoreDatable {
    var context: NSManagedObjectContext { get }
    
    func contextSave()
    func deleteObject(_ object: NSManagedObject?)
    func updateObject(_ item: NSManagedObject, handler: (NSManagedObject) -> Void)
}
extension CoreDatable {
// 프로토콜 익스텐션으로 기본구현을 작성함
    :
}
```

</div>
</details>
<br>

### 3. 스플릿 뷰의 설계 
<details>
<summary> SplitView 설계코드와 그 이유 </summary>
<div markdown="1">

- 기기의 사이즈마다 화면을 다르게 설계해야했는데, 처음에는 사이즈마다의 뷰컨트롤러를 생성하여 사이즈별로 화면을 구현하려고 했으나, `SplitViewController` 존재를 알고나서, 해당 뷰컨트롤러를 사용했다.

- iOS 14버전 부터 사용 가능한 `UISplitViewController` `column-style layouts` 을 사용하였다.
사실 이전에 사용하던 방식을 사용해보지 않아 어떤 차이가 있는 것 인지는 명확하게 구분하기 힘들지만, column을 사용하는게 핵심인 것 같다.

- 스토리보드를 이용하지않고, 코드로 스플릿 뷰 컨트롤러를 생성하고 윈도우의 루트뷰로 스플릿 뷰 컨트롤러를 추가하였다. 

```swift=
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SplitViewController(style: .doubleColumn)
        window?.makeKeyAndVisible()
    }
```

</div>
</details>

<br>

### 4. 뷰컨트롤러간의 데이터 전달방식을 델리게이트 패턴으로 구현

<details>
<summary> 뷰컨트롤러간 데이터 전달방식 설계와 그 이유</summary>
<div markdown="1">

- 데이터 모델을 사용하는 뷰컨트롤러가 `MemoListTableVC`(메모의 리스트를 보여주는 뷰컨트롤러) 메모의 내용을 보여주는 `MemoDetailVC`, 또한 새로운 메모를 작성하는 `ComposeTextVC가` 있었다. 뷰컨트롤러마다 같은 모델타입을 사용하니 처음에 모델을 싱글턴으로 만들어 구현하였다. 
하지만 여러 뷰컨트롤러에서 모델을 처리하는게 추후에 누군가가 코드를 봤을때나, 수정이 생길 경우 해당 VC를 찾아 수정을 해야되는 경우가 발생하니, 모델을 한 곳의 뷰컨트롤러에서 알고, 해당 뷰컨트롤러가 데이터를 하위 뷰컨트롤러에게 주입을 해주는게 더 나을 것 같다는 판단을 하였다.

    - 모델 싱글턴 방식을 더이상 사용하지 않고, `SplitViewController` 에서 모델 인스턴스를 속성으로 가지게 하였다.
    - 다른 뷰컨트롤러에서 메모 데이터 모델이 필요할 경우 델리게이트 패턴을 사용하여, SplitVC가 처리 할 수 있도록 하였다. 이로인해 데이터들이 한 곳에서 관리된다는 장점이 있었던 것 같고, 하지만 `SplitViewController가` 모든 데이터를 처리해주기 때문에, 유독 `SplitViewController가` 코드의 양이 늘어나는 단점을 찾을 수 있었다.

```swift=
//델리게이트 프로토콜 정의
protocol MemoListDelegate: AnyObject {
    func didTapTableViewCell(at indexPath: IndexPath)
    func didTapAddButton()
    func didTapDeleteButton(at indexPath: IndexPath)
    func didTapShareButton(at indexPath: IndexPath)
}

// 해당 작업을 대리해줄 뷰컨트롤러에게 프로토콜 메서드 요구사항을 구현한다. 
extension SplitViewController: MemoListDelegate {
    func didTapTableViewCell(at indexPath: IndexPath) {
        self.viewController(for: .secondary)?.view.isHidden = false
        let currentObject = coreDataMemo?.getCloudMemo(at: indexPath)
        memoDetailViewController.configureMemoContents(title: currentObject?.title,
                                                       body: currentObject?.body,
                                                       lastModifier: currentObject?.lastModified,
                                                       indexPath: indexPath)
        show(.secondary)
    }


class MemoListTableViewController {
// 기능을 대신해줄 델리게이트를 선언한다.
weak var delegate: MemoListDelegate?

// 기능을 대리자에게 맡기게 된다.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapTableViewCell(at: indexPath)
    }
}

    
```

</details>
</div>
<br>

### 5. 코어데이터 유닛 테스트
<details>
<summary> 코어데이터 유닛 테스트 </summary>
<div markdown="1">  
 
 - 코어데이터 모델을 생성한 뒤 영구저장소 타입을 InMemory타입으로 설정하였다. 이로써 메모리에만 영구저장이 일어남으로 실제 메모 데이터와 겹치는 일이 발생하지 않게 되었다.
```swift=
class CloudNotesTests: XCTestCase {
    var testCoreData: CoreDataCloudMemo!
    
    override func setUp() {
        super.setUp()
        let persistentStroeDescription = NSPersistentStoreDescription()
        persistentStroeDescription.type = NSInMemoryStoreType
        testCoreData = CoreDataCloudMemo(persistentStoreDescripntion: persistentStroeDescription)
    }
    
```
- 코어데이터의 CRUD 유닛 테스트를 진행하여 전부 성공하였다.
```swift=
   func test_코어데이터에_메모를_추가하는게_성공한다() {
        // given
        let newMemo = testCoreData.createNewMemo(title: "hi", body: "body", lastModifier: Date())
        
        // when
        let memos = try! testCoreData.context.fetch(CloudMemo.fetchRequest()) as! [CloudMemo]
        
        // then
        XCTAssertEqual(newMemo, memos.first!)
    }
    
    func test_코어데이터_메모를_삭제하는게_성공한다() {
        // given
        let newMemo = testCoreData.createNewMemo(title: "hi", body: "body", lastModifier: Date())
        
        // when
        testCoreData.deleteObject(_ object: newMemo)
        let memos = try! testCoreData.context.fetch(CloudMemo.fetchRequest()) as! [CloudMemo]
        
        // then
        XCTAssertTrue(memos.isEmpty)
    }
    
    func test_코어데이터_메모를_업데이트하는데_성공한다() {
        // given
        let newMemo = testCoreData.createNewMemo(title: "hi", body: "body", lastModifier: Date())

        // when
        testCoreData.updateObject(newMemo) { memo in
            let memo = memo as! CloudMemo
            memo.title = "newMemo"
            memo.body = "바디입니다."
        }
        
        let memos = try! testCoreData.context.fetch(CloudMemo.fetchRequest()) as! [CloudMemo]
        
        // then
        XCTAssertEqual(memos.first!.title, "newMemo")
    }
```
</div>
</details>
    <br>

### 6. 그 외 프로젝트 내부 코드와 이유

<details>
<summary>주요 코드</summary>
<div markdown="1">       

-  `NSFetchedResultsController` 를 사용하였다.`NSFetchedResultsControllerDelegate`를 제공함에 따라 메모리에 로드된 `ManagedObjectContext`가 변경사항이 있을때마다 델리게이트에게 알려줌으로써, 편하게 작업을 할 수 있었 던 것 같다. 나는 `DiffableDataSource`를 사용하였기 때문에, 변경사항을 스냅샷 처리를 하여 UI업데이트가 손쉽게 된다는 장점을 얻을 수 있었다.
```swift=
extension MemoListDiffableDataSource: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
    var newSnapshot = NSDiffableDataSourceSnapshot<String, CloudMemo>()

    snapshot.sectionIdentifiers.forEach { section in
        guard let section = section as? String else { return }

        newSnapshot.appendSections([section])

        let memos = snapshot.itemIdentifiersInSection(withIdentifier: section).compactMap { objectID -> CloudMemo? in
            guard let objectID = objectID as? NSManagedObjectID else { return nil }

            guard let cloudMemo =  coreDataMemo?.context.object(with: objectID) as? CloudMemo else { return nil }

            return cloudMemo
        }
        newSnapshot.appendItems(memos, toSection: section)
        newSnapshot.reloadItems(memos)
    }
    DispatchQueue.global().async { [weak self] in
        self?.apply(newSnapshot, animatingDifferences: true) {
            self?.coreDataMemo?.contextSave()
            }
        }
    }
}
```


- 텍스트뷰의 제목과, 본문을 분리하는 로직을 고차함수를 사용하여 작성하였다. 
    - `components(separatedBy: .newlines)` 을 사용하여, 스페이스바를 기준으로 문자열들을 쪼개 배열로 담아 처리하였다. 이후 `filter` 고차함수를 사용하여 제목과, 본문을 분리하였다.
    - 메모의 제목과 본문은 튜플을 사용하여 리턴을 해주었다.
```swift=
func separateText(_ text: String) -> (title: String?, body: String?) {
    let texts = text.components(separatedBy: .newlines)
    let title = texts.first
    var bodyText = ""
    texts.filter {
        texts[0].contains($0) == false ? true : false
    }.forEach { body in
        if body == texts.last {
            bodyText.append(body)
        } else {
            bodyText.append(body + "\n")
        }
    }

    return (title, bodyText)
}
```


- UIAlertController의 액션들을 배열로 받아 처리 할 수 있게 끔 타입메서드를 구현하였다.
```swift=
static func generateAlertController(title: String?, message: String?, style: UIAlertController.Style, alertActions: [UIAlertAction]?) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)

    alertActions?.forEach { alertAction in
        alert.addAction(alertAction)
    }

    return alert
}
```
<br>

- 상속이 필요치 않은 클래스 타입들에게 Final 키워드를 붙여줌.
클래스가 상속이 가능하다고 판단하면, 명시적으로 내가 아닌 다른사람들에게 해당 클래스는 상속이 불가능 하다고 알려줄 수 있는 장점이 있음.
또한 메서드들이 final 키워드가 없을시에는  Dynamic Dispatch로 인한 런타임시에 해당 메서드를 추적하는 비용이 더 들게됨. (상속이 가능하게되면, 접근제어자를 붙여준 곳에 한하여 해당 타입을 상속받아 오버라이딩을 할 수 있는 가능성이 있으니 컴파일 타임에 최적화 하기가 어렵다.)
하지만 Final 키워드를 붙여줌으로써 해당타입이 상속이 불가능함을 알리면 컴파일러는 메서드들이 Dynamic Dispatch가 아닌 Static Dispatch 메서드로 바뀔 수 있음. 인라이닝 기능 활성화
인라이닝이란 메서드가 호출되었을때 해당 메서드의 실행 구문이 메서드 실행부에 오게 하는 것 (추적비용 절감)



</div>
</details>

<br>

<br> 

## IV. Trouble Shooting
 - [1. 테이블뷰에서 뷰들이 한곳에 모여있는 에러](#테이블뷰에서-뷰들이-한곳에-모여있는-에러) <br>
 - [2. 테이블뷰의 Separator가 왼쪽에 끊어져 있는 에러](#테이블뷰의-Separator가-왼쪽에-끊어져-있는-에러)<br>
 - [3. DateFormatter locale이 제대로 적용이 안되는 문제](#DateFormatter-locale이-제대로-적용이-안되는-문제)<br>
 - [4. TextView의 스크롤의 시작부분이 제일 상단이 아닌, 중간쯤에 위치하는 에러](#TextView의-스크롤의-시작부분이-제일-상단이-아닌,-중간쯤에-위치하는-에러) <br>
 - [5. TableView의 오토레이아웃을 주지않았는데 왜 자동으로 적용이 될까?](#TableView의-오토레이아웃을-주지않았는데-왜-자동으로-적용이-될까)<br>
 - [6. 오토레이아웃 경고가 계속 뜨는 에러](#오토레이아웃-경고가-계속-뜨는-에러)<br>
 - [7. Split View에서 Secondary View가 계속 push 되는 에러](#Split-View에서-Secondary-View가-계속-push-되는-에러) <br>
 - [8. 테이블 뷰에서 스와이프가 작동이 안되는 에러](#테이블-뷰에서-스와이프가-작동이-안되는-에러) <br>
 - [9. 메모의 내용 수정시, 메모리스트에 수정된 내역이 반영이 안되는 에러](#메모의-내용-수정시,-메모리스트에-수정된-내역이-반영이-안되는-에러) <br>
 - [10. TextView의 Text가 마음대로 단어가 바뀌는 에러](#TextView의-Text가-마음대로-단어가-바뀌는-에러) <br>

### 테이블뷰에서 뷰들이 한곳에 모여있는 에러

####  원인

<img src="https://s3.us-west-2.amazonaws.com/secure.notion-static.com/a3e3b34c-8cdb-4ab8-a04a-dbe1af46fe00/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210923%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210923T072342Z&X-Amz-Expires=86400&X-Amz-Signature=64ede17e3cd561251bd9ad72dcc12c76e9315d2066187b69f43e820dd2aaa5d9&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22">

저 검은색들이 스택뷰로 ContentView에 addSubView를 한 것인데  저기에 셀이 다 모여있음... 왜그런걸까?

```swift
func configureLables() {
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fill
        horizontalStackView.spacing = 10
        horizontalStackView.addArrangedSubview(lastModifiedLabel)
        horizontalStackView.addArrangedSubview(bodyLabel)
        //horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(horizontalStackView)
        
        horizontalStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        horizontalStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: 10).isActive = true
        horizontalStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor, constant: -10).isActive = true
        horizontalStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: 20).isActive = true
    }
```

#### 해결

스택뷰에 `translatesAutoresizingMaskIntoConstraints` 옵션을 false로 바꾸니 해결되었다..

---
<br>

### 테이블뷰의 Separator가 왼쪽에 끊어져 있는 에러

#### 원인

<img src="https://s3.us-west-2.amazonaws.com/secure.notion-static.com/2aa1b386-48b3-4c0d-8064-f0dd79568846/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210923%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210923T072444Z&X-Amz-Expires=86400&X-Amz-Signature=6bbc81728b9d23f8010e94a2973b22979b3ded4479d426b58a263457c738f294&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22">

자세히 보면 왼쪽 Line이 이어져있지않음

#### 해결

`tableView.separatorInset` 으로 `UIEdgeInsets`을 다 0으로 주니 해결되었다.
`separatorInset` 의 기본값이 15로 되어 있는 것 같다. 왜그런걸까?

---
<br>

### DateFormatter locale이 제대로 적용이 안되는 문제.

#### 원인

<img src ="https://s3.us-west-2.amazonaws.com/secure.notion-static.com/98f8991e-bd5a-452b-ab41-fbc54906d67f/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210923%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210923T073416Z&X-Amz-Expires=86400&X-Amz-Signature=8cb162096fa90b07f495dc8f9e4d8d65c7182529f7febe1f0055c41a71ba7724&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22">

DateFormatter의 locale을 현재 기기상의 locale로 표현했는데

시뮬레이터에서는 계속 날짜가 영어권으로 나온다..

<img src="https://s3.us-west-2.amazonaws.com/secure.notion-static.com/de357c37-df82-4025-a35c-2a1db29f155f/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210923%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210923T073449Z&X-Amz-Expires=86400&X-Amz-Signature=3a8ab3bea354aa0e45204d8cf733a06e90d97fe9d83fbd7a8d4ae2319cc302bf&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22">

Locale.current를 print해보면

<img src="https://s3.us-west-2.amazonaws.com/secure.notion-static.com/0c43091b-41b4-4129-949a-3dc0b0d904c5/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210923%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210923T073507Z&X-Amz-Expires=86400&X-Amz-Signature=3bd67675a849f8e923734252fd854e81689413f859a60ff7ae31ea69876c2ab3&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22">

사용하는 언어가 en으로 되어있다.. 시뮬레이터에 아무리 한국어 설정을 해도 저부분이 바뀌지 않는다.

내가 뭘 잘못 알고 있는건가?.... 테스트가 안됨...

#### 해결

---

왜인지는 모르겠지만, 문서를 봤을때는 사용자의 지역설정에 따라 정보를 가져와야 하는데 안됨.

또한 공식문서에 설정앱에서의 사용자의 설정 언어를 가져오기 위한 방법은 `preferredLanguages` 를 사용하는 것을 권장함.  [Apple preferredLanguages](https://developer.apple.com/documentation/foundation/nslocale/1415614-preferredlanguages)

```swift
static func localizedString(of lastModifier: Int) -> String {
      let currentLanguage = Locale.preferredLanguages.first
      let dateFormatter = DateFormatter()
      let date = Date(timeIntervalSince1970: TimeInterval(lastModifier))
      
      dateFormatter.dateStyle = .long
      dateFormatter.locale = Locale(identifier: currentLanguage ?? "en_US")
      
      return dateFormatter.string(from: date)
}
```

이렇게 적용하니 사용자의 언어에 맞게 날짜 및 시간이 제대로 나옴!

--- 

<br>

### TextView의 스크롤의 시작부분이 제일 상단이 아닌, 중간쯤에 위치하는 에러
#### 원인

<img src = "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/49a33f6a-3ff3-4ea1-9eaa-bde62bc68604/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210923%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210923T073822Z&X-Amz-Expires=86400&X-Amz-Signature=6ea7f634ae0d99bade5e2e9bcea6447771999f459301627b623700bba486f7d9&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22">

<br>

<br>

- 디테일뷰의 텍스트뷰가 콘텐츠 스크롤이 생기면 스크롤위치가 맨위에 있지않고 해당 이미지와 같이 시작부분 보다 떨어진 위치에 있다.




#### 해결

```swift
viewDidLoad() {
    memoContentsTextView.contentOffset = CGPoint(x: 0, y: 0) 
}
```

이렇게 하니깐 됐다.

`contentOffset` 이라는게 

The point at which the origin of the content view is offset from the origin of the scroll view. 

라고하는데

offset을 잘몰라서 이해는 잘 안된다. 아마 위치에 대한 얘기같다. 
<br>


해결책은 위와 같고, 저렇게 된 이유를 리뷰어 비비에게 물어봤다.

TextView에 텍스트를 주입하는 시점에 레이아웃 업데이트 사이클이 제대로 수행되지 않아서 그런 것 같다고 한다. 해결 방법을 3가지 제시 해 주셨다.

Layout의 생명주기

- VC내의 View가 재계산되어 다시 그려지는 행위가 발생하면, `layoutSubViews`가 호출되고 View의 값이 갱신되고 나면 뒤이어 VC의 메소드인 `viewDidLayoutSubviews`가 호출된다.

1. 텍스트를 추가한 후 레이아웃 업데이트 사이클을 강제로 호출 시키거나(text Append 한 후 memoContetnsTextView 에 레이아웃 업데이트 메서드 호출)
    - `setNeededLayout` 메서드는, 이 메소드를 호출한 `View`는 재계산 되어야 하는 `view` 라고 수동으로 체크가 되며, update Cycle에서 `layoutSubviews`가 호출된다. 이 메소드는 비동기적으로 실행되기 때문에 호출바로 바로 리턴이 된다. View의 보여지는 모습은 update Cycle에 들어 갔을때 바뀐다.(약간 예약하는 느낌.)

    - `layoutIfNeeded()` 메서드는 `setNeededLayout`  와 같이 수동으로 layouySubviews를 예약하는 행위이지만, 해당 예약을 바로 실행시키는 즉 동기적으로 작동하는 메소드이다. update Cycle이 올때 까지 기다리는게 아닌, 그 직시 `layoutSubviews`를 발동시키는 메소드이다.

2.  UI 업데이트가 메인 스레드 안에서 동작 할 수 있도록 하거나
3. 현재와 같이 뷰가 나타나기 전에 ContentOffset을 0으로 지정.(현재는 `ViewDidLoad` 에서 `ContentOffset` 을 지정하고 있지만, 좀 더 정확한 위치는 `viewWillAppear(animated:)` 로 생각 된다.

---

### TableView의 오토레이아웃을 주지않았는데 왜 자동으로 적용이 될까?

#### 원인

왜 `tableview`의 오토레이아웃을 한적이 없는데 자동으로 오토레이아웃이 지정이 된 것 같다.

왜그런거지?

tableview를 상속받아서 그런것인가?

#### 해결

---

<img src = "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/72b1291e-4b4b-469f-b481-48260b75586a/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210923%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210923T074121Z&X-Amz-Expires=86400&X-Amz-Signature=64115fcf8a89cc21a42d577d77be7cbf5135a76dc1bc81efbc087d2ae07fd323&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22">

<br>
<br>

---

### 오토레이아웃 경고가 계속 뜨는 에러

#### 원인

기존 TableViewDataSource로 구현한 테이블뷰는 AutoLayout 경고?가 뜨지 않았음.

하지만 Diffable DataSource로 구현하니깐 에러? 오토레이아웃 경고문이 뜸

- 에러내용

    ```swift
    2021-09-02 20:11:28.629969+0900 CloudNotes[67460:9088556] [TableView] Warning once only: UITableView was told to layout its visible cells and other contents without being in the view hierarchy 
    (the table view or one of its superviews has not been added to a window). This may cause bugs by forcing views inside the table view to load and perform layout without accurate information (e.g. table view bounds, trait collection, layout margins, safe area insets, etc), 
    and will also cause unnecessary performance overhead due to extra layout passes. Make a symbolic breakpoint at UITableViewAlertForLayoutOutsideViewHierarchy to catch this in the debugger and see what caused this to occur, so you can avoid this action altogether if possible, or defer it until the table view has been added to a window. 
    Table view: <UITableView: 0x7fa837024400; frame = (0 0; 0 0); clipsToBounds = YES; autoresize = W+H; gestureRecognizers = <NSArray: 0x600003dfbc90>; layer = <CALayer: 0x6000033d5380>; contentOffset: {0, 0}; contentSize: {0, 0}; adjustedContentInset: {0, 0, 0, 0}; 
    dataSource: <_TtGC5UIKit29UITableViewDiffableDataSourceOC10CloudNotes27MemoListTableViewController7SectionVS1_4Memo_: 0x600003185b30>>
    2021-09-02 20:11:28.645359+0900 CloudNotes[67460:9088556] [LayoutConstraints] Unable to simultaneously satisfy constraints.
    	Probably at least one of the constraints in the following list is one you don't want. 
    	Try this: 
    		(1) look at each constraint and try to figure out which you don't expect; 
    		(2) find the code that added the unwanted constraint or constraints and fix it. 
    (
        "<NSLayoutConstraint:0x6000010b9090 UIStackView:0x7fa835c1f7a0.leading == UILayoutGuide:0x600000a85340'UIViewSafeAreaLayoutGuide'.leading + 10   (active)>",
        "<NSLayoutConstraint:0x6000010b90e0 UIStackView:0x7fa835c1f7a0.trailing == UILayoutGuide:0x600000a85340'UIViewSafeAreaLayoutGuide'.trailing   (active)>",
        "<NSLayoutConstraint:0x6000010bdb30 'UISV-alignment' UILabel:0x7fa835c1eaa0.leading == UIStackView:0x7fa835c08e90.leading   (active)>",
        "<NSLayoutConstraint:0x6000010bdb80 'UISV-alignment' UILabel:0x7fa835c1eaa0.trailing == UIStackView:0x7fa835c08e90.trailing   (active)>",
        "<NSLayoutConstraint:0x6000010bd630 'UISV-canvas-connection' UIStackView:0x7fa835c08e90.leading == UILabel:0x7fa835c1f530.leading   (active)>",
        "<NSLayoutConstraint:0x6000010bd680 'UISV-canvas-connection' H:[UILabel:0x7fa835c1f2c0]-(0)-|   (active, names: '|':UIStackView:0x7fa835c08e90 )>",
        "<NSLayoutConstraint:0x6000010bda90 'UISV-canvas-connection' UIStackView:0x7fa835c1f7a0.leading == UILabel:0x7fa835c1eaa0.leading   (active)>",
        "<NSLayoutConstraint:0x6000010bdae0 'UISV-canvas-connection' H:[UILabel:0x7fa835c1eaa0]-(0)-|   (active, names: '|':UIStackView:0x7fa835c1f7a0 )>",
        "<NSLayoutConstraint:0x6000010bd7c0 'UISV-spacing' H:[UILabel:0x7fa835c1f530]-(>=30)-[UILabel:0x7fa835c1f2c0]   (active)>",
        "<NSLayoutConstraint:0x6000010bdc20 'UIView-Encapsulated-Layout-Width' UITableViewCellContentView:0x7fa835c1fe40.width == 27.3333   (active)>",
        "<NSLayoutConstraint:0x6000010b8dc0 'UIViewSafeAreaLayoutGuide-left' H:|-(0)-[UILayoutGuide:0x600000a85340'UIViewSafeAreaLayoutGuide'](LTR)   (active, names: '|':UITableViewCellContentView:0x7fa835c1fe40 )>",
        "<NSLayoutConstraint:0x6000010b8e60 'UIViewSafeAreaLayoutGuide-right' H:[UILayoutGuide:0x600000a85340'UIViewSafeAreaLayoutGuide']-(0)-|(LTR)   (active, names: '|':UITableViewCellContentView:0x7fa835c1fe40 )>"
    )

    Will attempt to recover by breaking constraint 
    <NSLayoutConstraint:0x6000010bd7c0 'UISV-spacing' H:[UILabel:0x7fa835c1f530]-(>=30)-[UILabel:0x7fa835c1f2c0]   (active)>

    Make a symbolic breakpoint at UIViewAlertForUnsatisfiableConstraints to catch this in the debugger.
    The methods in the UIConstraintBasedLayoutDebugging
    ```

#### 해결

에러내용이 UITableView가 화면에 보이기 전에 (윈도우의 뷰 계층이 들어오기전) 레이아웃을 적용하려고 하고 있다.(dataSource.apply를 호출하고있다) 라고 해석 할 수 있다.

이에 해결 방법은 뷰 가 완전히 로딩된 시점에 UI 업데이트가 동작할 수 있도록 메인스레드에서 dataSource.apply 를 호출 하는 방법이 있다.

근데 궁금한게 난 비동기로 코딩을 한 적이 없는데, 아래처럼 코드를 쓰면 main 에서 main으로 작업을 맨 뒤로 미루게 되는 건가? 신기하다.

```swift
DispatchQueue.main.async {
	self.dataSource?.apply(snapShot, animatingDifferences: false, completion: nil)
}
```

apply 메서드는 백그라운드 스레드든, 메인스레드든 항상 일관된 큐에서 호출하는것이 필요하다고 언급함.

즉, 일관된 큐에서 동작하기만 한다면, 백그라운드 스레드에서도 안전한 호출을 보장 할 수 있다는 말이 됨.

>You can safely call this method from a background queue, but you must do so consistently in your app. Always call this method exclusively from the main queue or from a background queue.

```swift
DispatchQueue.global().async {
	self.dataSource?.apply(snapShot, animatingDifferences: false, completion: nil)
}
```

---

### Split View에서 Secondary View가 계속 push 되는 에러

#### 원인

<img src="https://s3.us-west-2.amazonaws.com/secure.notion-static.com/537668f7-a60b-422d-8b70-5b295f45ef8e/131966577-7928382a-32b6-4ed3-ad1c-266d6a5205f2.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210923%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210923T074751Z&X-Amz-Expires=86400&X-Amz-Signature=463e155b3026c7b30a5a3b7aef84af712c8a7369cb1238af94e4f4d8bc121c0d&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22131966577-7928382a-32b6-4ed3-ad1c-266d6a5205f2.gif%22">
<br>
<br>

```swift
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	  let detailVC = MemoDatailViewController()
	  detailVC.showContents(of: memo[indexPath.row])
	  
	  if UITraitCollection.current.horizontalSizeClass == .regular {
	      self.showDetailViewController(detailVC), sender: nil)
	  } else {
	      navigationController?.pushViewController(detailVC, animated: true)
	  }
        
 }
```

위에 코드처럼 TableView에서 탭을하면 현재 가로 화면 사이즈를 판단해 showDetail을 할지, 푸시를 할지 결정하였다. `showDetail` 을 하면 현재 `TableView`에 `NavigationController`가 있기때문에 push가 됨. 이에따라 계속 문제가 생긴다.  

#### 해결

먼저 TableView에서 처리하는게 아닌, Container인 SplitVC에서 처리하도록 델리게이트 패턴을 적용하였다.

공식문서에 이렇게 적혀있다.

> **Message Forwarding**
A split view controller interposes itself between the app’s window and its child view controllers. As a result, all messages to the child view controllers must flow through the split view controller. Messages are forwarded as appropriate. For example, view appearance and disappearance messages are sent only when the corresponding child view controller actually appears onscreen.



자식뷰컨트롤러 간의 메시지는 스플릿뷰컨을 통해 흘러야 된다고 써있기 때문이다.. 

그래서 TableVC → DetailVC 로 가는게 아닌

TableVC → SplitVC → DetailVC 로 하게끔 코드를 리팩토링 하였다.

```swift
//테이블뷰에서 델리게이트 패턴을 이용하여 행동을 대리자에게 위임.
override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didTapTableViewCell(memo[indexPath.row])
 }
```

위 코드처럼 셀을 탭했을때, 행동을 대리자에게 위임한다.

```swift

extension SplitViewController: MemoListDelegate {
    func didTapTableViewCell(_ memo: Memo) {
        memoDetailViewController.showContents(of: memo)
        show(.secondary)
    }
}
```

대리자는 `SplitViewController`이며, 해당 메서드를 구현한다.

이 부분에서 `show(_:)` 메서드를 활용하여 `SplitViewController`의 `secondary`가 표시되게끔 한다.

`show(_:)` 메서드는 자동으로 스플릿 동작에 사용할 수 있는 가장 가까운 모드로 변경 해 준다고 한다.
> When you call this method, the split view interface transitions to the closest display mode available for the current split behavior where the specified column is fully visible.

이에따라  문제가 해결되었다. 기존 분기문도 사라져서 깔끔한 느낌이 많이 난다.

---
<br>

### 테이블 뷰에서 스와이프가 작동이 안되는 에러

#### 원인
테이블 뷰의 스와이프 기능을 통하여 삭제를 구현하려 했음.

테이블뷰의 Delegate중 `tableView(_:canEditRowAt)`을 `true`를  줬으나 델리게이트가 전혀 작동을 안함.

`tableView(_: trailingSwipeActionsConfigurationForRowAt)` 메서드도 구현했으나 작동을 안함

뭐가 문제일까?

```swift
override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        MemoCoreData.shared.deleteMemoItem(at: indexPath)
      }

//스와이프가 작동을 안함.
```

#### 해결
`Diffable DataSource`는 `TableViewDataSource`를 채택하고 준수하고 있는 타입임.

데이터 소스를 설정할때 데이터 소스에대한 테이블뷰를 넣게 되어있음.

```swift
dataSource = MemoSourceData(tableView: self.tableView, cellProvider: { tableView, indexPath, memo in
      
    guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoListTableViewCell.identifier, for: indexPath) as? MemoListTableViewCell else { fatalError() }
    cell.configure(with: memo)
    
    return cell
        })
```

[Apple Developer Documentation](https://developer.apple.com/documentation/uikit/uitableviewdiffabledatasource/protocol_implementations)

여기에 가보면 `Diffable DataSource`가 `UITableViewDataSource` 어떤걸 구현했는지 보임.

그중 `canEditRowAt`이 있음. 이거를 오버라이딩하여 `true`를 주면 테이블뷰 스와이프가 작동이 되었음.

기본 `DataSoure`의 `canEditRowAt`이 `False` 인 것 같다.

 

---
<br>


### 메모의 내용 수정시, 메모리스트에 수정된 내역이 반영이 안되는 에러
#### 원인
<img src = "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f744ef83-ec87-4dcd-8e61-3ec97569e789/Simulator_Screen_Recording_-_iPhone_12_Pro_Max_-_2021-09-07_at_15.40.32.gif?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210923%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210923T075406Z&X-Amz-Expires=86400&X-Amz-Signature=6aeb92c3bd3f66bca3b61f7896f198c1d4b75a81767d0901d04df431fc95cccc&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Simulator%2520Screen%2520Recording%2520-%2520iPhone%252012%2520Pro%2520Max%2520-%25202021-09-07%2520at%252015.40.32.gif%22">

위 영상과 같이, 메모를 수정하고 나서 `List` 로 돌아갔을때  내용이 바뀌지 않는 증상이 발생함. 하지만 메모의 내용을 눌렀을때 `DetailVC` 에서는 반영이 되어 있음.

#### 해결
- 시도 1. `tableView reloadData` 메서드 호출

    - 결과 1. 성공함. 하지만 `Diffable DataSource`를 사용한 상태에서 굳이 해당 메서드를 사용하고 싶지 않았음.

- 시도 2. `viewDidAppear` 메서드에서 `Diffable Data Source` 재설정.

    - 결과 2. 성공함. 하지만 이 방법은 List VC가 보일때마다 `DataSource`를 설정하는 셈이 되니, 해당 방법은 별로 좋지 않은 방법 같다.

- 시도3. `snapshot reloadItem` 메서드 호출

    - 결과3. 성공함. snap의 reloadItem 메서드를 호출하게 되면 해당 지정된 항목의 `Item` 들의 내용을 다시 리로드 한다고 되어 있음. 약 2시간만에 해결
    - [reloadItems(_:)](https://developer.apple.com/documentation/appkit/nsdiffabledatasourcesnapshot/3395816-reloaditems)



--- 
<br> 

### TextView의 Text가 마음대로 단어가 바뀌는 에러
#### 원인
텍스트 입력시 앱이 자동으로 단어를 바꾸는 일이 발생함.

#### 해결
```swift
autocorrectionType = .no , .yes, .default
```

텍스트뷰의 `autocorrectionType`가 기본적으로 `.default` 로 되어있다고 한다.

`default` 인 경우 대부분의 경우 자동으로 활성화가 된다고 한다.

해당 프로퍼티를 `no` 로 설정해주면 더이상 자동으로 단어를 바꾸지않는다.

---
<br>

### 아이패드에서 얼러트(액션시트형식) 을 띄우려고 하면 에러가남

<details>
<summary>오류 내용</summary>
Thread 1: "Your application has presented a UIAlertController (<UIAlertController: 0x7f96f1861400>) of style UIAlertControllerStyleActionSheet from CloudNotes.SplitViewController (<CloudNotes.SplitViewController: 0x7f96efc099e0>). The modalPresentationStyle of a UIAlertController with this style is UIModalPresentationPopover. You must provide location information for this popover through the alert controller's popoverPresentationController. `You must provide either a sourceView and sourceRect or a barButtonItem`. If this information is not known when you present the alert controller, you may provide it in the UIPopoverPresentationControllerDelegate method -prepareForPopoverPresentation."

</details>
<br>

대충 해석하자면, 얼러트 모달스타일은 `UIModalPresentationPopover` 방식인데, 이 방식을 사용할때는 `barButtonItem` 또는 팝업에 대한 위치를(`sourceView`) 설정하라는 이유인 것 같다.

첫번째 해결 방법 sourceView설정하고(아마 superView 설정하는 느낌처럼) CGrect로 위치를 설정

```swift
 alert.popoverController?.sourceView = self.view
 alert.popoverController?.sourceRect = CGRect(x: view.bounds.minX, y: view.bounds.minY, width: 0, height: 0)
```

두번째 방법 `barButtonItem` 설정해 주기

```swift
alertController.popoverPresentationController?.barButtonItem = sender
present(alertController, animated: true, completion: nil)
```

`barButtonItem` 을 눌렀을때 `barButtonItem` 아래에 액션시트가 뜨고 싶다면 위와같이 !   

---
<br><br><br>

## V.아쉽거나 해결하지 못한 부분
### NSFetchedResultsController Delegate는 누가 위임받아 처리할까?

1. Diffable DataSource 
    - 현재 델리게이트가 구현되있는 곳. `Delegate`가 `snapshot` 을 만들고 `apply`한다는 점에서  데이터소스의 역활이 가장 맞지 않나 라고 생각을 했음.
2. CoreDataCloudMemo
    - 메모 코어데이터들의 CRUD가 구성되어있는곳이다.  MVC의 Model 역화을 한다고 생각했음.

        델리게이트 역활이 현재 메모리에 올려져있는 `context`의 데이터가 변화 되었을때 호출되는 `Dlegate`다 보니, 이곳도 델리게이트의 역활(didChangeContentWith method)을 할 수 있다는 생각이 강하게 들었다.

        하지만 해당 클래스에서 델리게이트를 구현한다고 하면,  Diffable DataSource를  참조해야됨. 변화된 내용을 델리게이트 메서드에서 처리해준 뒤 Diffable DataSource에 변경된 내용을 담아 apply해야 되니. 모델의 역활이 맞나?. 맞는 것 같기도 하고.. 잘 모르겠다.

---

### UITextView가 키보드 아래로 내려갈때 텍스트가 보이지 않는 부분.
- 해당 부분은 구글검색으로 해결방법은 찾았으나, 이해가 안되는 코드라서 프로젝트에는 적용하지 않았다.
아직 frame 과 bounds에 대한 이해를 잘 하지 못하여 그런 듯 하니 좀 더 공부를 해봐야겠다.

--- 

### 메모를 수정하려고 하면 Layout 에러가 디버그 창에 표시됨
- 에러

    ```swift
    2021-09-14 16:01:45.180715+0900 CloudNotes[24777:1679791] 
    [TableView] Warning once only: UITableView was told to layout its visible cells and other contents without being in the view hierarchy 
    (the table view or one of its superviews has not been added to a window).
     This may cause bugs by forcing views inside the table view to load and perform layout without accurate information 
    (e.g. table view bounds, trait collection, layout margins, safe area insets, etc), 
    and will also cause unnecessary performance overhead due to extra layout passes.
     Make a symbolic breakpoint at UITableViewAlertForLayoutOutsideViewHierarchy to catch this in the debugger and see what caused this to occur, so you can avoid this action altogether if possible, or defer it until the table view has been added to a window.
     Table view: <UITableView: 0x7fe630817800; frame = (0 0; 428 926); clipsToBounds = YES; autoresize = W+H; gestureRecognizers = <NSArray: 0x600002ea09f0>; layer = <CALayer: 0x600002099ba0>; contentOffset: {0, -91}; contentSize: {428, 80}; adjustedContentInset: {91, 0, 34, 0}; dataSource: <CloudNotes.MemoListDiffableDataSource: 0x6000020e32c0>>
    ```

the table view or one of its superviews has not been added to a window 이 줄이 핵심인 것 같은데,

왜 뜨는거지? TableView는 push 되었지만, 아직 메모리에 안사라져있다. 그러면 VC는 살아있고, 레이아웃도 살아 있는 것 아닌가? 이 부분은 해결 하지 못하였다.

---

### Git에 Pod 폴더가 올라가 있다. Pod파일을 GitHub에 올리는건 지양하는 방법. 어떻게 처리해야 될까?

현재 내 Repo Step1에 Pod 폴더가 같이 올라가 있다. 이 방법은 용량도 많이 차지하고,, 지양하는 방법이라고 한다.

근데 이걸 어떻게 해결해야 될 지 모르겠다.............. 새롭게 Repo를 받는다?. 

이 부분은 해결하지 못하였다.

--- 

<br><br><br>
## VI. 관련 학습 내용 
#### 학습 키워드
- 스토리 보드 없애고 사용하기.
- SplitView
- Core Data
<br>
    
<details>
    <summary>학습내용 정리</summary>
    <div markdown="1">       

## 1. 스토리 보드 없애고 사용하기.
<img src = "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/3c083d53-9444-413c-82b1-d44a4663e352/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210924%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210924T022309Z&X-Amz-Expires=86400&X-Amz-Signature=eb155e3b74b1e510d3acb1f90b65711366de24a6895e16702fc98a064c15fced&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22">
<br>

<br>

- info.plist 에서 해당 항목을 삭제한다. 이후 `SeneDelegate`로 이동하여 scene(_: WillConnectTo:)메서드에 아래와 같이 작성한다.

```swift=
guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = UINavigationController(rootViewController: ViewController())
    window?.makeKeyAndVisible() // 이거를 하지 않으면 화면에 보이지않음
```
<br>
<img src = "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/ce489510-aa82-4aad-842c-898428c5844c/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210924%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210924T022856Z&X-Amz-Expires=86400&X-Amz-Signature=f0f8a8842db864e945af20ed5b47261024b9297ebfa5fe5b85a25df3da2a685d&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22">

<br>

<br>

`window?.makeKeyAndVisible()` 메서드를 호출해주지 않으면, View들이 나타나지 않는다.
뷰의 계층에도 아무것도 없음.
`makeKeyAndVisible()` 은 해당 윈도우를 `keyWindow` 로 설정 및 `visible contents` 하라는 의미

> `keyWindow` = 터치 관련된 이벤트가 아닌 이벤트나, 키보드 이벤트 등을 받고 있는 윈도우이다.
한 시점에서 하나의 윈도우만 `keyWindow`이다.
The key window receives keyboard and other non-touch related events.

<details>
<summary>Window</summary>

### 정의
모든 iOS App은 하나이상의 `UIWindow` 인스턴스가 필요하다. 어떤 앱들은 하나 이상의 윈도우가 포함될 수 있다. 윈도우 인스턴스는 아래와 같은 일을 한다.
- 어플리케이션의 `visibel Content`를 포함한다.
- 어플리케이션의 뷰나 다른 객체 터치 이벤트를 전달하는 중요한 역활을 수행한다.
- 화면 회전 변화(orientation change)에 대한 대응을 쉽게 할 수 있도록 앱의 `ViewController`들 과 상호작용한다.

iOS에서 `Window`는 다른 뷰들을 담는 빈 컨테이너로 동작하며, 앱 라이프 사이클 동안 하나의 윈도우만 생성하고, 이 `Window`는 앱 실행 초기에 로드 되야 한다. 

</details>

--- 

## 2. SplitView
### 정의

![SpiltView](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/3090dc8c-bea3-429c-8494-b3ab8acc8778/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210924%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210924T025129Z&X-Amz-Expires=86400&X-Amz-Signature=7a8907f4c1874b7a0d3015673700b0adaa97b657dc96602f40454c98508323f0&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)

- 스플릿뷰 컨트롤러는 계층 인터페이스에서, 자식 뷰 컨트롤러를 관리하는 컨테이너 뷰 컨트롤러이다.
- 해당 유형의 인터페이스에서는 뷰컨트롤러의 변경이 다른 콘텐츠 뷰의 내용을 변경한다.
- 계층 구조 탐색에 가장 적합하다.
- 스플릿뷰 컨트롤러는 window의 루트뷰 컨트롤러가 된다.
- 자체적으로 중요한 모양이 없다. 대부분의 View는 자식뷰컨에의해 정의가 된다.

> 스플릿뷰 컨트롤러를 네비게이션 컨트롤러 스택에 푸시 할 수 없다!!
일부 다른 컨테이너 뷰컨에 스플릿 뷰를 자식으로 등록 할 수 있지만. 대부분의 경우 권장되지 않는 방법이다.

### SplitView Style

![Untitled](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/9b871d5e-bb26-4dc4-8993-e1c8eca9c646/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210924%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210924T025100Z&X-Amz-Expires=86400&X-Amz-Signature=614014ecc67d0e748bd1f2277ee2040b70956ca953ea6110fe67bda0c1e8b89c&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)

- iOS 14 이상에서 는 컬럼 스타일 레이아웃을 지원한다.
- 컬럼 스타일 스플릿 뷰 컨트롤러를 사용하면 적절한 스타일과 함께 두 개 또는 세 개의 컬럼이 있는 인터페이스를 만들 수 있다.
- `UISplitViewController.Style.doubleColumn` 을  사용하면, 2열 레이아웃으로 스플릿 뷰 컨트롤러를 만든다. 이 컨트롤러는 primary, secondary columns 두 개의 컨트롤러를 관리하게 된다.
- iOS 14 이전에는 스플릿뷰 컨트롤러가 primary 컨트롤러와 secondary 컨트롤러가 있는 스타일만 지원했다.
<br>
### Child View Controllers
- `cloumn-style SplitView`에서 `setViewController(_:for:)` 및 `viewController(for:)` 메서드를 사용하여 각 `cloumn`에 대한 뷰 컨트롤러를 설정하고 가져 올 수 있습니다.
- `SplitViewController`는 `NavagationController`에서 모든 `childVC`를 래핑한다. 네비게이션컨트롤러가 없는 일반 뷰컨트롤러를 스플릿뷰컨트롤러에 설정(`setViewController(_:for:)`)하면 스플릿뷰컨트롤러는 네비게이션 컨트롤러를 만들고 뷰컨트롤러에 Set하게 된다. (그냥 뷰컨트롤러가 아닌 네비게이션 컨트롤러가 달려있게됨)
- `viewController(for:)`를 통해 원래 뷰 컨트롤러를 반환하지만, 그 `children`속성에는 뷰 컨트롤러를 래핑하는데 사용한 `Navigation Controller`가 포함되어 있다. 
- `show(_:)` or `hide(_:)`로 해당 컬럼을 표시하거나, 숨길 수 있다.

--- 

## 3.Core Data

###  정의

- Core Data는 객체 그래프 관리자 이다. 객체 그래프 관리자란 무엇인가?
객체 그래프란 ? 서로 연결되어 있는 개체의 집합이다. Core Data 프레임 워크는 복잡한 개체 그래프를
관리하는데 탁월하다.
- Core Data 프레임워크는 개체 그래프에서 개체의 수명 주기를 관리한다. 선택적으로 개체그래프를 디스크에 유지 할 수 있으며, 관리하는 개체 그래프를 검색하기 위한 강력한 인터페이스도 제공한다.
- Core Data는 그 이상이다. 프레임워크는 such as input validation , data model vesionning, change tracking 까지 가능하다.

#### 저장 방식

- 코어데이터는 객체 그래프 관리자라고 했으니, 관리하는 도구 일 뿐이고 저장방식은 무엇이 잇을까?
    - SQLite 처럼 데이터베이스를 저장소로 사용 할 수 있다.
    - 이진 저장소도 사용이 가능하다. 메모리 저장소도 지원한다.

---

### 객체 그래프 관리자 (Object Graph Manager)

- 코어데이터의 정의는 애플에서는 앱을 위해 모델(Model) 계층의 객체를 관리하는데 사용하는 프레임워크이자, 라이프 사이클이나 영속성 관리를 위한 기능을 제공하는 객체 그래프 관리자 라고 한다.
- 코어데이터는 영구 저장소에 저장된 각각의 레코드를 읽어온 다음, 독립적인 객체를 만들어 낸다.
우리가 데이터를 다르는 행위는 코어 데이터에서 모두 객체 단위로 이루어진다. 
이때 레코드의 데이터가 객체화된 것을 가리켜 관리되는 객체 (Managed Object) , 관리 객체라고 부른다.
- 코어데이터가 객체 그래프를 관리를 담당하는 것은 객체들을 연결 할 수 있으며, 이 연결을 통해 영속적으로 동기화 된다는 뜻이다. 만약 A,B라는 객체가 연결되어 있는 상태에서 A에서 업데이트가 되면, B에서도 연관된 데이터의 업데이트가 수행된다. 삭제도 마찬가지이다.

### 코어데이터의 구조

- 코어데이터는 다층 구조로 이루어진 프레임워크로, 각 층을 담당하는 핵심 객체들이 밀접한 연관성을 가친 채 상호작용하게 된다. 전체적으로 코어 데이터는 개발자와 영구 저장소 사이를 이어주는 프레임워크 이다.

![Untitled](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/2af3b0ff-3ce2-47ab-8f0b-6ea98cdb2442/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210924%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210924T031304Z&X-Amz-Expires=86400&X-Amz-Signature=d801ef4dd30292e31e660f658c620777127fb14cbf651477d9536ec819a5bd2a&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)

### 관리객체 (Managed Object)

- 관리객체는 코어 데이터에서 데이터를 저장하기 위해 생성하는 인스턴스이다. 관계형 DB에서는 테이블의 행, 레코드 정도로 생각하면 된다. 행과 레코드는 아래 그램 참조, Row라고 보면 될 듯.

![Untitled3](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/67515318-1b4a-4abc-9913-9465f374535b/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210924%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210924T031544Z&X-Amz-Expires=86400&X-Amz-Signature=c50f7def0748c4ef8955cfce488afee4fc379c056619b4e5376029199b13378a&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)

<br>


#### 데이터베이스와 코어데이터의 차이?

- 데이터 베이스는 말그대로 데이터들이 모여있는 집합소이다. 데이터를 저장하기 위한 곳인 것이다.

    둘의 차이는 명확하다. 코어데이터는 객체 그래프를 관리하는 프레임 워크고,

    DB는 말그대로 데이터들의 집합소인 것이다.

    코어데이터는 DB를 저장소로 쓸 수 있지만, 프레임워크 자체는 DB가 아닌 것 이다.


---

### Core Data 까보기

![Untitled](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/5f2fec32-88ba-4fa9-8e91-77bfe6f71731/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210924%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210924T031801Z&X-Amz-Expires=86400&X-Amz-Signature=b08147514a55189881d2562d6b60e95991d968faf162a1ba73966fa033c7bb18&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)

### Managed Object (관리 객체)

#### 정의

- 코어데이터에서 데이터를 저장하기 위해 생성하는 인스턴스이다.
- 관계형 데이터 베이스에서 행(ROW)나 레코드로 생각하면 된다.
- 테이블의 행의 해당하는 데이터가 코어데이터에서는 독립된 객체로 동작을 하게 된다.

### Managerd Object Context (관리 객체 컨텍스트)

#### 정의

- 코어데이터에서 가장 핵심적인 객체로,  크게 두가지 역활을 담당한다.
- 첫번째 역활은 MO(Managed Object) 를 담거나, 생성, 삭제 할 수 있는 역활을 한다.코어데이터에 생성되는 MO는 모두 컨텍스트에 담겨 관리가 된다. 우리는 컨텍스트를 통해 새로운 MO를 생성하거나, 기존 MO삭제, Context에 있는 모든 MO를 영구저장소에 보내 저장 할 수 도 있다.
- 두번째 역활은 영구 저장소 (Persistent  Store) 및 영구 저장소 코디네이터 (Persistent Store Coordinator)에 대한 관리자이다. 
컨텍스트는 영구 저장소 코디네이터와 매우 밀접되어 있으며, 우리가 요청하는 읽기 및 쓰기 요청을 처리한다.
코어데이터에서 가장중요한게 컨텍스트의 참조를 획득하는 것.

### Persistent Store Coordinator(영구저장소 코디네이터)

#### 정의

- 코디네이터는 컨텍스트와 직접 데이터를 주고 받으면서 다양한 영구 저장소의 접근을 조정하고, 해당 저장소에 실제 입출력을 담당한다.

### Managed Object Model (관리 객체 모델)

#### 정의
- DB로 치자면, 테이블의 구조를 정의하는 스키마에 해당됨.
- 코어데이터에서 테이블에 대응하는 엔티티(Entity)의 구조를 정의하는 객체인 동시에 이 스키마를 바탕으로 정의된 MO 패턴의 모델 클래스를 가르킨다.(클래스 타입이 생성되나봐요)
- Managed Object에 저장될 데이터 구조에 대한 정보를 담고 있다.
- 관리 객체 모델은 Xcode에서 설계한 엔티티로부터 생성된다.

- Managed Object와 Managed Object Model을 헷갈려 하는 경우가 있음.  정확히 구분하자면 MOM은 타입이다. MO는 MOM이 인스턴스화 된 것임.

### Persistent Object Store (영구 객체 저장소)

#### 정의

- 코어데이터를 사용할때 데이터가 저장되는 저장소 환경을 말한다.
- 저장소의 타입은 총 4가지
    - 인메모리 타입 - 휘발성 메모리에 올리고 프로그램 종료시 삭제됨.
    - 플랫 바이너리 - 2진파일
    - XML (iOS 지원안함)
    - SQLite (디폴트 값임)

---

 

### 엔티티(Entity)

#### 정의

- 데이터가 저장될 구조 및 형식임. 관계형 DB에서 테이블을 생각하면 된다,
- 내부 구성은 크게 3가지 속성(Attribute), 릴레이션(Relation), 패치 속성(Fetched Properties)가 있다.
- 속성은 컬럼이라고 보면될까?
- 릴레이션은 다른 엔티티와의 관계를 정의하는 역활.
- 데이터 검색시 반복요청 이나, 값만 바꾸어 사용하는 비슷한 요청들을 미리 템플릿 화 해 놓은 것을 말함.

#### 엔티티의 상속 과 추상화

- 엔티티는 상속이 가능하다. 클래스와 비슷한 방식으로 동작을 하는데, 일부만 차이가 있는 유사한 엔티티 들이 여러 개 있을 경우 엔티티마다 동일한 Attribute를 정의하는 대신 공통 Attibute를 뽑아 상위 엔티티를 정의하고, 나머지 엔티티들은 이를 상속받는 하위 엔티티로 정의하여 사용할 수 있다.
- Abstract Entity를 체크하게되면 MO인스턴스 생성이 안되며 이 엔티티를 상속받는 하위 엔티티만 MO인스턴스 생성 가능.

    ![Untitled](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/c18f66b0-31a5-4556-93ad-1e2a4ef193e2/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210924%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210924T032254Z&X-Amz-Expires=86400&X-Amz-Signature=e46b27b6f027f68a704c3265ff6cbd6ced00ddbc1f07007d6a98b02bade0fe2c&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)

- Parent Entity에서 상속받고 싶은 Entity 선택가능.

### Managed Object Model Class

- 엔티티가 정의 되면 자동으로 엔티티구조를 객체형태로 변환한 데이터 모델 클래스 를 생성한다.
- 엔티티 인스펙터에서 Class 이름을 설정 할 수 있다.
- Xcode에서 자동으로 생성하는 데이터 모델 클래스는 개발자가 손을 대거나 수정할 수 없을 뿐만 아니라 탐색기 영역에도 나타나지 않는다.. 필요하다면 커스텀 모델 클래스를 명시적으로 정의해서 사용 할 수 있다.(왠만하면 이렇게 쓰자)
- 커스텀 모델 클래스 명시적으로 생성시 Entity 인스펙터에서 Codegen 을 꼭 Menual, None으로 변경해주자. 이걸 안해놓으면 커스텀클래스를 생성하고 코어데이터에서도 모델 클래스를 또 만들게 됨. 충돌 남.

### NSPersistentContainer

![Untitled](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/ef55c8ee-f5db-4189-a4e2-55884e5c56fc/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210924%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210924T031924Z&X-Amz-Expires=86400&X-Amz-Signature=cf596daa9635ae90d3192e2fea9f6a8e0969bb6574f92658abbe001d11379a0b&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22)

- Persistent Container는 그림과 같이 Model Context, Store Coordinator, Model이 포함되어있음.
- Manage and persist your app’s model layer.
- Core Data Stack을 나타내는 필요한 모든 객체를 포함한 컨테이너.
- 프로젝트에 CoreData를 체크했으면 Appdelegate에 코드가 추가 되어 있음.
    - 코드

        ```swift
        lazy var persistentContainer: NSPersistentCloudKitContainer = {
                let container = NSPersistentCloudKitContainer(name: "CloudNotes")
                container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                    if let error = error as NSError? {
                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
                })
                return container
            }()
            
            func saveContext () {
                let context = persistentContainer.viewContext
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        let nserror = error as NSError
                        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                    }
                }
            }
        ```

        저장소 컨테이너는 바로 초기화가 되는게 아닌 호출될때 초기화가 된다.

        saveContext는 커밋개념이라 보면됨 자주 호출은 좋지 않고, 컨텍스트에 변경사항이 있으면(모델의 변화) 컨텍스트에 save.

## NSFetchRequest<Result>

- 코어데이터에 저장된 데이터를 가져올때 요청사항을 정의한 NSFetchRequest 인스턴스가 사용된다.
- 다양한 요청을 복합적으로 정의 할 수 있다. 대표적인 요청은 아래와 같다.
    - 어디에서 데이터를 가져올 것인가? (엔티티지정)
    - 어떤 데이터를 가져올 것인가? (검색조건 지정)
    - 어떻게 데이터를 가져 올 것인가? (정렬 조건 지정)

## NSEntityDescription

- 엔터티는 관리 개체에 대해 클래스가 id에 대해, 또는 데이터베이스에 비유하자면 테이블이 행에 대해 설명하는 것입니다. 인스턴스는 엔티티의 이름, 속성(NSAttributeDescription 및 NSRelationshipDescription의 인스턴스로 표현되는 속성 및 관계) 및 엔티티를 나타내는 클래스를 지정합니다.

    NSEntityDescription 개체는 인스턴스가 Core Data Framework를 사용하는 애플리케이션의 영구 저장소에 있는 항목을 나타내는 데 사용되는 특정 클래스와 연결됩니다. 최소한 엔터티 설명에는 다음이 포함되어야 합니다.

    - Name
    - The name of a managed object class

    (엔티티에 관리 객체 클래스 이름이 없으면 기본적으로 NSManagedObject가 됩니다.)

## NSFetchResultsController

- Core Data Fetch 요청 결과를 관리하거나, 사용자에게 데이터를 보여주기 위해 사용하는 컨트롤러.

### 컨트롤러가 하는일

- 연결된 managed object context 의 변경사항을 모니터링 하고, 결과의 변경사항을 (Set) delegate에게 알림
- 동일한 데이터가 이후에 다시 표시되는 경우 작업을 반복할 필요가 없도록 캐싱도 가능함.
- 컨트롤러는 대리자가 있는지, 캐시 파일 이름이 설정되어있는지 여부에 따라 3가지 작동방법으로 나뉨
    - No Tracking: Delegate 가 nil 일때, 컨트롤러는 단순히 Fetch가 되었을때와 같이 데이터에 대한 엑세스를 제공한다.
    - Memory-Only Tracking: Delegate가 nil이 아니고, 캐시 파일 이름이 nil일때. 컨트롤러는 results를 모니터링하고 관련 변경에 대한 response로 섹션과 정보를 업데이트함.
    - Full Persistent Tracking: Delegate와 File cache가 nil이 아닐때. Memory-Only Tracking 업무에 + 영구 캐시를 유지한다.

### 사용법

- 일반적으로 NSfetchedResultsController의 인스턴스를 테이블뷰 컨트롤러의 인스턴스 변수로 생성한다.
- 컨트롤러를 초기화 할때 4개의 매개변수를 제공한다.
    - FetchRequest: Fetch요청임. 결과를 정렬하기위해 적어도 정렬 descriptor 가  있어야함.
    - Managed Object Context:  해당 컨텍스트를 사용하여 Fetch request를 실행함.
    - 옵셔널 Section Name Key Path : 컨트롤러는 key Path 를 사용해 결과를 섹션으로 분리함( nil이면 컨트롤러가 단일 섹션을 생성)
    - 옵셔널 Cache Name: 컨트롤러가 사용해야 하는 캐시파일 이름(nil이면 캐싱방지됨) 캐시를 사용하면 섹셕 및 인덱스 정보를 계산하는 오버헤드를 피할 수 있다.

- 인스턴스를 생성한 후 실제로 Fetch 하기위한 performFetch를 호출한다.
- 애플이 짜 놓은 예시 코드

    ```swift
    let context = <#Managed object context#>
    let fetchRequest = NSFetchRequest<AAAEmployeeMO>(entityName: "Employee")
    // Configure the request's entity, and optionally its predicate
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "<#Sort key#>", ascending: true)]
    let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    do {
        try controller.performFetch()
    } catch {
        fatalError("Failed to fetch entities: \(error)")
    }
    ```

### Controller Delegate

- delegate를 설정하면, 컨트롤러가 context의 변경 알림을 수신하도록 설정한다. context에 모든 변경 사항이 처리되고 그에 따라 결과가 업데이트된다.

### Implementing the Table View Datasource Methods

- Code

    ```swift
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let frc = <#Fetched results controller#> {
            return frc.sections!.count
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.<#Fetched results controller#>?.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = <#Get the cell#>
        guard let object = self.<#Fetched results controller#>?.object(at: indexPath) else {
            fatalError("Attempt to configure cell without a managed object")
        }
        // Configure the cell with data from the managed object.
        return cell
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = <#Fetched results controller#>?.sections?[section] else {
            return nil
        }
        return sectionInfo.name
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return <#Fetched results controller#>?.sectionIndexTitles
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        guard let result = <#Fetched results controller#>?.section(forSectionIndexTitle: title, at: index) else {
            fatalError("Unable to locate section for \(title) at index: \(index)")
        }
        return result
    }
    ```

</div>
</details>



