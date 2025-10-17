<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;
use Illuminate\Auth\Notifications\VerifyEmail;
use Illuminate\Support\Carbon;
use Illuminate\Support\HtmlString;
use Illuminate\Support\Facades\URL;

class CustomVerifyEmail extends VerifyEmail
{
    use Queueable;

    protected $role;
    protected $password;

    /**
     * Create a new notification instance.
     */
    public function __construct($role, $password)
    {
         $this->role = $role;
         $this->password = $password;
    }

    protected function verificationUrl($notifiable)
    {
        return URL::temporarySignedRoute(
            'verification.verify',
            Carbon::now()->addMinutes(60),
            ['id' => $notifiable->getKey(), 'hash' => sha1($notifiable->getEmailForVerification())]
        );
    }

    /**
     * Get the notification's delivery channels.
     *
     * @return array<int, string>
     */
    // public function via(object $notifiable): array
    // {
    //     return ['mail'];
    // }

    /**
     * Get the mail representation of the notification.
     */
    public function toMail($notifiable)
    {
        $pw_txt = $this->role=='faculty' ? 'temporary' : '';
        $pchange = $this->role=='faculty' ? 'Please change it after logging in.' : '';
        $pw_html = '';
        if ($this->password) {
            $pw_html = new HtmlString('Your ' . $pw_txt . ' password is: <b>' . $this->password . '</b>');
        }
        
        return (new MailMessage)
            ->subject('Verify Your Email Address')
            ->greeting('Hi ' . $notifiable->first_name . '!')
            ->line('Please verify your email to continue.')
            ->action('Verify Email', $this->verificationUrl($notifiable))
            ->line($pw_html)
            ->line($pchange)
            ->line('If you didn’t register, please ignore this email.');
    }

    /**
     * Get the array representation of the notification.
     *
     * @return array<string, mixed>
     */
    // public function toArray(object $notifiable): array
    // {
    //     return [
    //         //
    //     ];
    // }
}
