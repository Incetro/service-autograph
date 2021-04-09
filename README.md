# service-autograph

Services code generator based on [Autograph](https://github.com/Incetro/autograph) and [Synopsis](https://github.com/Incetro/synopsis) frameworks.

# Usage
## Prepare your service protocols

Your services protocols should look like this:

```swift
/// @service (mandatory annotation) ServiceName (optional)
///
/// If you don't specify your service's name there just
/// be used `GeneratedImplementation` suffix.
/// `SandboxService` will be converted to `SandboxServiceGeneratedImplementation`
protocol SandboxService {

    /// Each service method must return ServiceCall or CancelableServiceCall
    ///
    /// You can specify url that will describe your request's endpoint:
    /// @url /users (there will be GET request because GET is a default method)
    ///
    /// If you want, you can add DAO method here (the method will describe
    /// what to do with result entities)
    /// @persist
    ///
    /// Supported dao methods: persist, read, erase.
    /// These methods will automatically adjust to your method's logic
    /// (more information you can find in Sandbox folder)
    func obtain() -> ServiceCall<[UserPlainObject]>

    /// You can use parametrized urls:
    /// @url /users/{id}
    func obtain(
        userId id: Int /// @url (will be injected into your url)
    ) -> ServiceCall<UserPlainObject>

    /// You can use other HTTP methods.
    ///
    /// @url /users/{id}
    /// @patch (and get, post, put, delete also available)
    func update(
        userId id: Int, /// @url
        name: String    /// @json first_name
    ) -> ServiceCall<UserPlainObject>

    /// @url /users
    ///
    /// There are several serialization options: url, json, header, query.
    /// Argument's name is an implicit annotation value
    func obtain(
        page: Int,    /// @header X-Pagination-Current-Page
        pageSize: Int /// @header X-Pagination-Per-Page
    ) -> ServiceCall<[UserPlainObject]>

    /// If you don't specify the url, service-autograph will think
    /// that method should work with DAO – result will be taken from
    /// a local database (not from network)
    /// @read
    func read(userId id: Int) -> ServiceCall<UserPlainObject?>
}
```

**service-autograph** will generate implementations for each of your service protocols. More information you can find in example [service folder](https://github.com/Incetro/service-autograph/tree/master/Sources/sandbox/Sandbox/BusinessLayer/Services/UserService).

## Annotations

### Methods

| Annotation   | Description                                                                         | Example            |
|--------------|-------------------------------------------------------------------------------------|--------------------|
| `@url param` | method's request endpoint                                                           | `@url /users`      |
| `@url param` | method's request endpoint                                                           | `@url /users/{id}` |
| `@persist`   | DAO will persist result entity/entites in a local database                          | `@persist`         |
| `@erase`     | DAO will erase target entity/entites from a local database                          | `@erase`           |
| `@read`      | DAO will obtain entity/entites from a local database and return them in ServiceCall | `@read`            |
| `@get`       | Set a request's http method to GET                                                  | `@get`             |
| `@post`      | Set a request's http method to POST                                                 | `@post`            |
| `@put`       | Set a request's http method to PUT                                                  | `@put`             |
| `@patch`     | Set a request's http method to PATCH                                                | `@patch`           |
| `@delete`    | Set a request's http method to DELETE                                               | `@delete`          |

### Parameters

| Annotation     | Description                                                               | Example                             |
|----------------|---------------------------------------------------------------------------|-------------------------------------|
| `@url name`    | parameter will be added to request's url template (parameter is optional) | `@url id` / `@url`                  |
| `@header name` | parameter will be added to request's headers. (parameter is optional)     | `@header X-Pagination-Current-Page` |
| `@query name`  | parameter will be added to request's query (parameter is optional)        | `@query age` / `@query`             |
| `@json name`   | parameter will be added to request's body (parameter is optional)         | `@json first_name` / `@json`        |

## Setup steps

**1. Add submodule to your project.**

`git@github.com:Incetro/service-autograph`

**2. Init submodules in your project.**

```bash
git submodule init
git submodule update
```

**3. Run `spm_build.command` to build executable file.**

You should take it from `.build/release/service-autograph` and place inside your project folder (for example in folder `Codegen`)

**4. Add run script phase in Xcode.**

It may look like this:

```bash
SERVICE_AUTOGRAPH_PATH=Codegen/service-autograph

if [ -f $SERVICE_AUTOGRAPH_PATH ]
then
    echo "service-autograph executable found"
else
    osascript -e 'tell app "Xcode" to display dialog "Service generator executable not found in \nCodegen/service-autograph" buttons {"OK"} with icon caution'
fi

$SERVICE_AUTOGRAPH_PATH \
    -services "$SRCROOT/$PROJECT_NAME/BusinessLayer/Services/" \
    -plains "$SRCROOT/$PROJECT_NAME/Models/Plain" \
    -project_name $PROJECT_NAME
```

Available arguments

| Parameter         | Description                                                                       | Example                                                          |
|-------------------|-----------------------------------------------------------------------------------|------------------------------------------------------------------|
| help              | Print help info                                                                   | `./service-autograph -help`                                      |
| projectName       | Project name to be used in generated files                                        | `./service-autograph -projectName yourName`                      |
| plains            | Path to the folder, where plain objects files to be processed are stored          | `./service-autograph -plains "./Models/Plain"`                   |
| services          | Path to the folder, where service protocols files should be placed                | `./service-autograph -models "./BusinessLayer/Services"`         |
| output            | Path to the folder, where generated service files should be placed                | `./service-autograph -models "./BusinessLayer/Services/Gen"`     |
| verbose           | Forces generator to print the whole process of generation                         | `./service-autograph -verbose`                                   |

**5. Add generated files manually to your project.**

## Example project

You can see how it works in the exmaple folder `Sources/sandbox`. Run `sandbox_run.command` and then there will be several options to test the generator:

1. You can add or remove some method from service protocol, open implementation file and press `Cmd B` – you'll see how it changes (new method implementation will be added)
2. You can clear implementation file and press `Cmd B` – you will see that service will be generated
3. Eventually, you can create a new service protocol and press `Cmd B` – implementation class will be placed inside folder `/BusinessLayer/Services/YourNewService` (but you should still add them manually to the project)

## 

