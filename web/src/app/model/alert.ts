export class AlertType {
    type: string = ''
    message: string = ''
    status: string = 'send'
    constructor(type: string, message: string) {
        this.type = type
        this.message = message
    }
}