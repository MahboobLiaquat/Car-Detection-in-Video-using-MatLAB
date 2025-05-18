# 🚗 Car Detection in Video using GMM and EM

This project was developed as part of **ENCS6161: Probability and Stochastic Processes** at **Concordia University** during Winter 2023. It involves using a **Gaussian Mixture Model (GMM)** and the **Expectation-Maximization (EM)** algorithm to detect the number of cars in a video sequence. The project replaces MATLAB’s built-in `fitgmdist` with a custom implementation, `myfitgmdist`, to deepen understanding and control of the detection process.

## 📌 Abstract

This project explores the use of Gaussian distribution to detect cars in video sequences. The objective is to understand the utility of the **Gaussian Mixture Model (GMM)** and **Expectation-Maximization (EM)** algorithm in video analysis. The video is segmented into N frames, and a histogram is constructed for each pixel across time. A GMM is fitted using EM on this data (grayscale and RGB), enabling foreground detection. Bounding boxes are then used to count and display cars in each frame. The results validate this as a reliable method for traffic surveillance applications.

---

## 🗂️ Project Structure

```plaintext
gmm-car-detection-video/
│
├── README.md                       # Project overview
├── report/
│   └── ENCS6161_Project_Report.pdf # Full report with methodology and results
├── code/
│   ├── main_script.m               # Main driver code
│   ├── myfitgmdist.m               # Custom EM + GMM function
│   ├── foregroundDetector.m        # Foreground extraction logic
│   ├── myhist.m                    # Custom histogram generator (if used)
│   └── expandHist.m                # Expands histogram for GMM fitting
├── figures/
│   ├── flowchart_method.png        # Methodology flowchart
│   ├── em_algorithm.png            # EM algorithm flow
│   ├── car_detected.png            # Sample car detection result
│   └── no_car.png                  # Sample empty frame result
└── sample_video/
    └── smallSizeVideo.avi         # Resized input video (or placeholder)
