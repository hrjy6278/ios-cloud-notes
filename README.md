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
 - [1. LazyLoading Probelm](#1-lazyloading-probelm)<br>
 - [2. HTTP Request POST시에 HTTP Message 503Error 가 Response 되는 에러!](#2-http-request-post시에-http-message-503error-가-response-되는-에러)<br>
 - [3. DataSource 와 Delegate가 분리된 상황에서 Model DATA를 여러군데에서 참조 할 수 있는 방법](#3-datasource-와-delegate가-분리된-상황에서-model-data를-여러군데에서-참조-할-수-있는-방법)<br>
 - [4. Delegate타입을 따로 만들고 ViewController에서 할당 하였는데 반영되지 않는 문제](#4-delegate타입을-따로-만들고-viewcontroller에서-할당-하였는데-반영되지-않는-문제)<br>
 - [5. CodingKey 프로토콜을 채택했음에도 채택하지 않았다는 경고 메세지가 나온 문제](#5-codingkey-프로토콜을-채택했음에도-채택하지-않았다는-경고-메세지가-나온-문제)<br>
 - [6. cell의 textLabel에 데이터 및 속성이 제대로 반영되지 않는 문제](#6-cell의-textlabel에-데이터-및-속성이-제대로-반영되지-않는-문제)<br>

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
### 뷰들이 한곳에 모여 있는 에러

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

### 테이블뷰의 Separator가 왼쪽에 끊어져있음.

#### 원인

<img src="https://s3.us-west-2.amazonaws.com/secure.notion-static.com/2aa1b386-48b3-4c0d-8064-f0dd79568846/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210923%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210923T072444Z&X-Amz-Expires=86400&X-Amz-Signature=6bbc81728b9d23f8010e94a2973b22979b3ded4479d426b58a263457c738f294&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22">

자세히 보면 왼쪽 Line이 이어져있지않음

#### 해결

`tableView.separatorInset` 으로 `UIEdgeInsets`을 다 0으로 주니 해결되었다.
`separatorInset` 의 기본값이 15로 되어 있는 것 같다. 왜그런걸까?

---
<br>

### 아이폰 가로 모드일때 좌측 여백이 너무 많음

#### 원인

<img src="https://s3.us-west-2.amazonaws.com/secure.notion-static.com/391eca9b-66d1-426c-a23a-022c580c1fbc/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210923%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210923T072622Z&X-Amz-Expires=86400&X-Amz-Signature=752ed4faf557933db0b0d36b17fade7e06b840d2cb3a7a78c2d8f34a1056e464&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Untitled.png%22">
<br>

<br>

아이패드는 문제 없음.

아이폰 widht - Regular, height - Compact일때 (가로모드일때)

테이블뷰가 저렇게 좌측여백이 너무 많이 생김

height가 Regular 일때는 이렇지않다 어떻게 해야 하지?

#### 해결

`Bottom` 이나 `Top` 에 `View` `SafeArea` 때문에 저렇게 여백이 생김.

리뷰어 비비의 말로는 저게 문제가 되는 거라고 생각하지않는다고 함. 

나도 그렇게 생각하고 넘어 감. 

---

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

### TextView의 스크롤의 시작부분이 제일 상단이 아닌, 중간쯤에 위치함.

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

### Git에 Pod 폴더가 올라가 있다. 지양하는방법이라하는데 어떻게 처리하지?

현재 내 Repo Step1에 Pod 폴더가 같이 올라가 있다. 이 방법은 용량도 많이 차지하고,, 지양하는 방법이라고 한다.

근데 이걸 어떻게 해결해야 될 지 모르겠다.............. 새롭게 Repo를 받는다?...

[gitignore.io](https://www.toptal.com/developers/gitignore)

이그노어(올릴파일 제외) 를 언어에 맞는걸 생성해주는 사이트

---

### 오토레이아웃 경고가 계속 뜬다.

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

### Split View에서 Secondary View가 계속 push 되는 문제.

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

### 스와이프가 작동이 안되는 에러

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


### 메모의 내용 수정시, 메모리스트에 수정된 내역이 반영이 안됨.


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

### TextView의 Text가 자기 마음대로 단어가 바뀜.
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


## UIAlertController에 대한 코드 리팩토링.

현재 메모앱에서 좌측 상단 네비게이션 버튼을 누르면 액션시트가 띄워져야함.

그렇기에 해당 기능을 코드를 구현해서 넣었음

```swift
static func generateSeeMoreAlertController(deleteHandler: @escaping (UIAlertAction) -> Void,
                                             shareHandler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: NameSpace.delete, style: .destructive, handler: { alert in
        deleteHandler(alert)
    }))
    alert.addAction(UIAlertAction(title: NameSpace.share, style: .default, handler: { alert in
        shareHandler(alert)
    }))
    alert.addAction(UIAlertAction(title: NameSpace.cancel, style: .cancel, handler: nil))
    
    return alert
    }
```

해당 메서드를 사용하면 `AlertController가` 생성이되어 리턴해주는 느낌임. 
근데 해당 메서드는 무조건 **공유**, **삭제** 가 필요할때만 사용하는 메서드임. 해당 경우는 언제든지 바뀔수 있다고 판단했음.(나중에 추가해달라고하면 여기에 계속 늘어나거나 삭제 될 것 같기에.) 

그래서 해당 코드를 좀 더 공용적으로 사용 할 순 없을까 고민을 하게되었음..

시도 방향은 

 어떤메소드에 컴플리션 핸들러를 파라미터로 받아, UIAlertAction을 리턴해준다.

해당 얼러트 액션을 메서드의 파라미터로 넣어주게되면 add 하여 uialertcontroller를 리턴하게?

```swift
enum Kind: CustomStringConvertible {
        case share
        case delete
        case cancel
        
        var description: String {
            switch self {
            case .share:
                return "Share..."
            case .delete:
                return "Delete"
            case .cancel:
                return "Cancel"
            }
        }
    }
  
static func generateUIAlertAction(kind: Kind, alertStyle: UIAlertAction.Style, completionHandler: ((UIAlertAction) -> Void)?) -> UIAlertAction {
    return UIAlertAction(title: String(describing: kind), style: alertStyle) {
        completionHandler?($0)
    }
}
```

얼러트 액션을 만들어주는 메서드. 메소드를 실행할때 컴플리션핸들러 파라미터로 함수를 받아 UIAlertAction을 생성한 다음 리턴해준다.

```swift
enum NameSpace {
        static let delete = "Delete"
        static let share = "Share..."
        static let cancel = "Cancel"
    }

static func generateAlertController(title: String?, message: String?, style: UIAlertController.Style, alertActions: [UIAlertAction]?) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: style)

    alertActions?.forEach { alertAction in
        alert.addAction(alertAction)
    }
    
    return alert
}
```

얼러트 컨트롤러를 생성하고 리턴해주는 부분.

액션을 배열로 받아 배열에 담긴 액션을 얼러트에 추가해준다. 그런다음 얼러트컨트롤러를 리턴해준다. 

이렇게 사용하면 좀 더 범용성이 좋아 지지 않을까?

---

## NSFetchedResultsController Delegate는 누가 위임받아 처리할까?

1. Diffable DataSource 
    - 현재 델리게이트가 구현되있는 곳. `Delegate`가 `snapshot` 을 만들고 `apply`한다는 점에서  데이터소스의 역활이 가장 맞지 않나 라고 생각을 했음.
2. CoreDataCloudMemo
    - 메모 코어데이터들의 CRUD가 구성되어있는곳이다.  MVC의 Model 역화을 한다고 생각했음.

        델리게이트 역활이 현재 메모리에 올려져있는 `context`의 데이터가 변화 되었을때 호출되는 `Dlegate`다 보니, 이곳도 델리게이트의 역활(didChangeContentWith method)을 할 수 있다는 생각이 강하게 들었다.

        하지만 해당 클래스에서 델리게이트를 구현한다고 하면,  Diffable DataSource를  참조해야됨. 변화된 내용을 델리게이트 메서드에서 처리해준 뒤 Diffable DataSource에 변경된 내용을 담아 apply해야 되니. 모델의 역활이 맞나?. 맞는 것 같기도 하고.. 잘 모르겠다.

---




## 메모를 수정하려고 하면 Layout 에러가 뜸 ㅜㅜ

저번과 비슷한 에러가 뜸.

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

왜 뜨는거지? TableView는 push 되었지만, 아직 메모리에 안사라져있다. 그러면 VC는 살아있고, 레이아웃도 살아 있는 것 아닌가?

---

## 아이패드에서 얼러트(액션시트형식) 을 띄우려고 하면 에러가남

> 에러 내용

Thread 1: "Your application has presented a UIAlertController (<UIAlertController: 0x7f96f1861400>) of style UIAlertControllerStyleActionSheet from CloudNotes.SplitViewController (<CloudNotes.SplitViewController: 0x7f96efc099e0>). The modalPresentationStyle of a UIAlertController with this style is UIModalPresentationPopover. You must provide location information for this popover through the alert controller's popoverPresentationController. `You must provide either a sourceView and sourceRect or a barButtonItem`. If this information is not known when you present the alert controller, you may provide it in the UIPopoverPresentationControllerDelegate method -prepareForPopoverPresentation."

대충 해석하자면, 얼러트 모달스타일은 `UIModalPresentationPopover` 방식인데, 이 방식을 사용할때는 `barButtonItem` 또는 팝업에 대한 위치를(`sourceView`) 설정하라는 이유인 것 같음....하아..

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




---

## VI. 관련 학습 내용 
#### 학습 키워드
- HTTP
- 네트워크 통신
- url Session
- Cache
- Paging
- UICollectionView
- 비동기 통신
<br>
    
<details>
    <summary>학습내용 정리</summary>
    <div markdown="1">       

#### 1. HTTP 
(1) HTTP란?
- hyper text trasition protocol 을 줄임말. 네트워크 통신을 이용하여 데이터를 주고 받기 위하여 생긴 약속이다.
- 클라이언트가 url을 통하여 `request(요청)` 하면 서버에서는 해당 요청사항에 맞는 결과를 `response(응답)` 하는 형태로 동작한다. 

(2) Request 와 Response
 - Request Message
    - HTTP Request는 넓게보면 세가지 종류가 있다. 시작라인, 헤더, 바디
    - start Line은 서버가 수행해야할 동작을 나타낸다. HTTP request method를 명시.
    - Header는 요청의 내용을 좀 더 구체와 시키고, 조건에 따른 제약사항을 넣기도 한다. 
    - Body는 리소스를 가져오는 Request는 보통 본문이 없다. 전달해야될 내용이 없기 때문이다. 일부 요청은 업데이트를 위해 서버에 데이터를 전송한다. POST시 그럴 확률이 높다. Data를 Body에 담아 request 요청을 한다.
    - Body의 종류는 단일 리소스, 각기 다른 리소스가 있을 경우 멀티파트를 사용한다.
    - Request HTTP 메시지 예시 
    ```swift
    POST / HTTP / 1.1                   <- 시작부분
    HOST: localhost:8000                <- header
    Content-Type: multipart/form-data;  <- header
    Content-Length: 333                 <- header
    //한칸띄어쓰면 그 이후에는 본문이 시작된다.
    -123456          <- body
    (more Data)      <- body
    ``` 
- Response Message
    



#### 2. URLSession
- URLSession은 HTTP, HTTPS 를 통해 콘텐츠를 주고 받는 apple 에서 API를 제공해주는 클래스이다.
- URLSession은 세가지 유형을 제공하고 있다. URLSession 개체가 가지고 있는 `Confiruation` 프로퍼티로 결정 할 수 있다.
    - 기본적인 동작 방법은 Session Confiruation을 결정하고 URLSession을 생성한다.
통신을 할 URL과 Request 를 설정한다.
사용할 Task를 결정하고 Task를 실행한다.
네트워크 통신은 기본적으로 비동기 처리 임으로 탈출 클로저를 사용하여, 통신이 완료됐을 때 동작을 설정한다.


- Task
    - Task 개체는 Session이 `request`을 보낸 후, `response`를 받을 때 내용들을 받는 역활을 하게 된다. 3가지 종류의 Task가 있다. 
        - Data Task = Data 개체를 통해 주고받는 Task이다.
        - Download Task = Data를 파일의 형태로 전환 후 다운 받는 Task이다. 백그라운드에서 다운할 수 있는 기능을 지원한다.
        - Upload Task = Data를 파일의 형태로 전환 후 업로드 할 수 있는 Task이다.

- URLRequest
    - URLRequest를 통하여 서버로 `request`를 보낼 때 어떤 HTTP Request Method를 사용할 것인지, 어떤 내용을 전송할 것인지 설정 할 수 있다. 
    - HTTPRequest의 setValue, addValue을 사용하여 헤더메시지를 설정하거나, 추가 할 수 있다. 
    - 프로젝트 URLRequest 적용사항.
    ```swift
    private static func createRequest(httpMethod: HTTPMethod, url: URL, body: Data?, _ contentType: ContentType) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue("\(contentType); boundary=\(Boundary.literal)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = String(describing: httpMethod)
        request.httpBody = body
        return request

    // URLRequest의 헤더를 설정하고, 
    // 어떤 request 할지 httpMethod에 설정하고, 
    // httpbody에 데이터를 넣어
    // URLRequest를 리턴하게 된다. 
    }
    ``` 
<br>


#### 2. Lazy Loading 
- lazy Loading이란?
    - Lazy loading is a design pattern commonly used in computer programming to defer initialization of an object until the point at which it is needed. 즉 필요한 순간에만 초기화되도록 하는 디자인 패턴이다. 
    - 테이블뷰나 컬렉션뷰의 경우 주로 `tableVeiw(_:cellForRowAt:)`, `collectionView(_:cellForItemAt:)` 메소드에서 `cell`이 스크린에 보여지기 직전 혹은 보여지기 전에 `cell`을 구성할 contents들을 위한 객체를 구현한다. 


#### 3. Cache
(1) Cache란?
- 자주 사용하는 데이터나 값을 미리 복사해 놓는 임시장소
- 언제 사용 : 캐시접근하는 시간과 서버에 있는 데이터에 접근하는 시간 중 후자가 더 오래걸리는 경우, 값을 다시 계산하는 시간을 절약하고 싶은 경우에 사용
- 장점 : 더 빠른 속도로 데이터에 접근할 수 있다. 
- 구분의 기준 : local and Global, 저장 장소, 지역성에 따라 캐쉬의 구분이 달라진다. 

    
     
#### 4. UICollectionView
<img src="https://user-images.githubusercontent.com/71247008/131329119-da338da1-ceff-4a48-8646-9270e2c4d08f.png" width="400" height="300">
<br><br>

- 컬렉션뷰는 테이블뷰와 비슷한 구조를 가지고 있다. `View`에 나타내야하는 정보를 `DataSource`로 요구하며, 이벤트와 같은 기능을 `Delegate`로 구현하고 있다. 다만 다른점이 있다면, `CollectionViewFlowLayout` 으로 셀의 크기와 너비를 설정해주어야 한다.
- 기본적으로 DataSource 구현은 TableView와 많이 닮아 있다. numberOfSections 메서드로 섹션의 갯수를 지정해 줄 수 있으며, numberOfItemsInSection 메서드로 섹션안에 셀이 얼마나 있어야 할지 알려주게 된다. 마지막으로 cellForItemAt 메서드로 셀을 생성하고, 해당 셀에 데이터를 주입시켜 반환을 시키면 된다.

```swift
//    섹션의 갯수를 설정하는 부분
func numberOfSections(in collectionView: UICollectionView) -> Int {
        OpenMarketDataSource.openMarketItemList.count
    }
//    섹션에 셀의 갯수를 설정하는 부분
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        OpenMarketDataSource.openMarketItemList[section].items.count
    }
//    Cell을 생성하며, Cell을 configure하여 Cell을 return 해주는 역활을 담당.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "openMarketCell", for: indexPath) as? OpenMarketItemCell else {
            return UICollectionViewCell()
        }
```

- UICollectionViewFlowLayout
<img src="https://user-images.githubusercontent.com/71247008/131330825-95071f5d-ed95-459b-980a-64101bd31e10.png" width="400" height="200">
    - FlowLayout은 콜렉션 뷰의 delegate 나 Flowlayout 클래스의 프로퍼티를 사용하여 셋팅 할 수 있다.
    - delegate는 CollecvionView가 header 나 footer 를 설정하거나, 셀마다 Size를 다르게 하고 싶을 때 유용하다고 하다.




</div>
</details>
