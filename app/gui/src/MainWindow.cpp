#include <MainWindow.hpp>
#include <QPixmap>
#include <QResizeEvent>

MainWindow::MainWindow() : renderController(this), centralLabel{nullptr} {
    resize(1080, 1024);
    centralLabel = new QLabel(this);
    centralLabel->setSizePolicy(QSizePolicy::Ignored,
                                QSizePolicy::Ignored);
    setCentralWidget(centralLabel);
}

void MainWindow::display(QImage image)
{
    centralLabel->setPixmap(QPixmap::fromImage(image));
    emit displayed();
}

void MainWindow::resizeEvent (QResizeEvent *event)
{
    emit sizeChanged(event->size());
}