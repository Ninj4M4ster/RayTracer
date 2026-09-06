#include <MainWindow.hpp>
#include <QPixmap>

MainWindow::MainWindow() : renderController(this), centralLabel{nullptr} {
    centralLabel = new QLabel(this);
    this->setCentralWidget(centralLabel);
}

void MainWindow::display(QImage image) {
    centralLabel->setPixmap(QPixmap::fromImage(image));
    emit displayed();
}