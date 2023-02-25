# iOS-
서비스의 iOS 부분을 담당하는 저장소 입니다.

<br>

## ✏️ Commit Convention
### Head
1. 기능을 태그로 작성한다.
2. 어떤 부분을 수정했는지 표시하기 위해서 태그 뒤에 괄호로 커밋한 기능명을 작성한다.
3. 설명은 대문자, 동사원형으로 작성 시작한다. Tag : Feat, Fix, Design, Rename, Remove, Comment, !HOTFIX, Docs

ex) Feat(Review): Add no review screen

### Body
1. '어떻게' 변경했는지 보다 '무엇을', '왜' 변경했는지 작성 (방법보다 사유 기술)

### Tail(이슈트래킹은 런칭 이후에 진행)
Format : '유형(Type): #이슈 번호'
1. 여러 개의 이슈 작성 상황에는 쉼표로 구분
2. 유형 (Type) <br>

ex) close : #12

|유형|의미|
|---|---|
|Close|이슈 닫음|
|Fixes|이슈 수정중 (아직 해결되지 않은 이슈)|
|Ref|참고할 이슈가 있을 때|
|Resolves|이슈를 해결했을 때 (이슈 닫음)|
|Related to|해당 커밋에 관련된 이슈번호|


<br><br>

## 💡 Github
### 🌿 Branch 전략

### 브랜치 카테고리
- master : 제품으로 출시될 수 있는 브랜치 <br>
- develop : 다음 출시 버전을 개발하는 브랜치 <br>
- feature : 기능을 개발하는 브랜치 (네이밍 : feature/{issue num}-{feature name} ex. feature/17-login), 해당 기능 구현시 상의 후 브랜치 제거 <br>

<br>

<img src = "https://techblog.woowahan.com/wp-content/uploads/img/2017-10-30/github-flow_repository_structure.png" width="70%" height="50%">
<br><br><br>

1. 새로운 기능 개발 이전에는 코드 충돌 가능성을 줄이기 위해, 항상 Upstream Repository로부터 Local Repository로 Pull하여 작업을 시작한다.
2. Local Repository에서 작업 완료 시, Origin Repository에 Push 한다.
3. Github에서 Origin Repository에 push한 브랜치를 Upstream Repository로 merge하는 PR(Pull Request)을 생성하고 코드 리뷰를 거친 후 merge 한다.
4. 단, 코드 작성자는 이미 내용을 알고 있기 때문에, 번거로운 작업을 줄이기 위해 committer가 아닌, 상대방이 리뷰한다.

<br>

### Git-flow 채택

<br><br>
<p align="center">
<img src = "https://techblog.woowahan.com/wp-content/uploads/img/2017-10-30/git-flow_overall_graph.png" 
width="55%" height="40%"></p>
<br><br>

1. 새로운 기능 추가 작업이 있는 경우 develop 브랜치에서 feature 브랜치를 생성한다.
2. feature 브랜치는 언제나 develop 브랜치에서부터 시작한다.
3. 기능 추가 작업이 완료되었다면, feature 브랜치는 develop 브랜치로 merge한다.
4. 버전을 출시할 때에는 master 브랜치에 버전 태그를 추가한다.


---

**PR Template**

[https://github.com/just1103/BookFinder/pull/1](https://github.com/just1103/BookFinder/pull/1)

```visual-basic
## 개요
내용을 적어주세요.

## 작업사항
- 내용을 적어주세요.

## 변경로직
- 내용을 적어주세요.
```
