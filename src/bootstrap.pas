(*!------------------------------------------------------------
 * [[APP_NAME]] ([[APP_URL]])
 *
 * @link      [[APP_REPOSITORY_URL]]
 * @copyright Copyright (c) [[COPYRIGHT_YEAR]] [[COPYRIGHT_HOLDER]]
 * @license   [[LICENSE_URL]] ([[LICENSE]])
 *------------------------------------------------------------- *)
unit bootstrap;

interface

uses

    fano;

type

    TAppServiceProvider = class(TDaemonAppServiceProvider)
    protected
        function buildAppConfig(const container : IDependencyContainer) : IAppConfiguration; override;
        function buildDispatcher(
            const container : IDependencyContainer;
            const routeMatcher : IRouteMatcher;
            const config : IAppConfiguration
        ) : IDispatcher; override;

    public
        procedure register(const container : IDependencyContainer); override;
    end;

    TAppRoutes = class(TRouteBuilder)
    public
        procedure buildRoutes(
            const container : IDependencyContainer;
            const router : IRouter
        ); override;
    end;

implementation

uses
    sysutils

    (*! -------------------------------
     *   controllers factory
     *----------------------------------- *)
    {---- put your controller factory here ---},
    HomeControllerFactory;


    function TAppServiceProvider.buildAppConfig(const container : IDependencyContainer) : IAppConfiguration;
    begin
        container.add(
            'config',
            TJsonFileConfigFactory.create(
                getCurrentDir() + '/config/config.json'
            )
        );
        container.alias(GuidToString(IAppConfiguration), 'config');
        result := container['config'] as IAppConfiguration;

    end;

    function TAppServiceProvider.buildDispatcher(
        const container : IDependencyContainer;
        const routeMatcher : IRouteMatcher;
        const config : IAppConfiguration
    ) : IDispatcher;
    begin
        container.add('appMiddlewares', TMiddlewareListFactory.create());

        container.add(
            GuidToString(IDispatcher),
            TDispatcherFactory.create(
                container['appMiddlewares'] as IMiddlewareLinkList,
                routeMatcher,
                TRequestResponseFactory.create()
            )
        );
        result := container[GuidToString(IDispatcher)] as IDispatcher;
    end;

    procedure TAppServiceProvider.register(const container : IDependencyContainer);
    var config : IAppConfiguration;
    begin
        config := container['config'] as IAppConfiguration;

        {$INCLUDE Dependencies/dependencies.inc}
    end;

    procedure TAppRoutes.buildRoutes(
        const container : IDependencyContainer;
        const router : IRouter
    );
    begin
        {$INCLUDE Routes/routes.inc}
    end;
end.