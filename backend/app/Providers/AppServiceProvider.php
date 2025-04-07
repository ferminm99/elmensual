<?php

namespace App\Providers;
use Illuminate\Support\Facades\Config;

use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
        // $this->app->singleton(EnsureFrontendRequestsAreStateful::class, function () {
        //     return new CustomEnsureFrontendRequestsAreStateful;
        // });
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        //
        Config::set('session.same_site', 'none');
    }
}