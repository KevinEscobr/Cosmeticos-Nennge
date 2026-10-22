<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Hash;
use App\Models\User;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

Artisan::command('admin:create {email? : El correo del administrador} {--password= : Contraseña (opcional)} {--name= : Nombre del usuario} {--phone= : Teléfono (opcional)}', function () {
    $email = $this->argument('email') ?: $this->ask('Ingresa el correo del administrador', 'admin@dobleencanto.com');
    $name = $this->option('name') ?: $this->ask('Ingresa el nombre del administrador', 'Administradora Doble Encanto');
    $phone = $this->option('phone') ?: $this->ask('Ingresa el teléfono del administrador (opcional)', '+56900000000');

    $password = $this->option('password');
    if (!$password) {
        $password = $this->secret('Ingresa la contraseña segura para el administrador');
        $confirm = $this->secret('Confirma la contraseña');
        if ($password !== $confirm) {
            $this->error('Las contraseñas no coinciden.');
            return 1;
        }
    }

    if (empty($password) || strlen($password) < 8) {
        $this->error('Por seguridad, la contraseña debe tener al menos 8 caracteres.');
        return 1;
    }

    $user = User::updateOrCreate(
        ['email' => $email],
        [
            'name' => $name,
            'phone' => $phone,
            'password' => Hash::make($password),
            'is_admin' => true,
            'email_verified_at' => now(),
        ]
    );

    $this->info("✓ Administrador [{$user->email}] configurado exitosamente con privilegios completos.");
    return 0;
})->purpose('Crea o actualiza un usuario administrador seguro para Doble Encanto');
