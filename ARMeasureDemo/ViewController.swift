//
//  ViewController.swift
//  ARMeasureDemo
//
//  Created by Amjad Khan on 27/11/17.
//  Copyright © 2017 HCL. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var nodes: [SphereNode] = []
    
    lazy var sceneView: ARSCNView = {
        let view = ARSCNView(frame: CGRect.zero)
        view.delegate = self
        return view
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.title1)
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(sceneView)
        view.addSubview(infoLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        sceneView.frame = view.bounds
        infoLabel.frame = CGRect(x: 0, y: 16, width: view.bounds.width, height: 64)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        let tapLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(tapLocation, types: .featurePoint)
        if let result = hitTestResult.first {
            let position = SCNVector3.positionFrom(matrix: result.worldTransform)
            let sphere = SphereNode(position: position)
            sceneView.scene.rootNode.addChildNode(sphere)
            let lastNode = nodes.last
            nodes.append(sphere)
            if lastNode != nil {
                let distance = lastNode!.position.distance(to: sphere.position)
                infoLabel.text = String(format: "Distance %.2f meters", distance)
            }
        }
    }

    //MARK: ARSCNViewDelegate
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        var status = "Loading..."
        
        switch camera.trackingState {
        case ARCamera.TrackingState.notAvailable:
            status = "Not Available"
        case ARCamera.TrackingState.limited(_):
            status = "Analyzing"
        case ARCamera.TrackingState.normal:
            status = "Ready"
        }
        
        infoLabel.text = status
    }

}

extension SCNVector3 {
    func distance(to destination: SCNVector3) -> CGFloat {
        let dx = destination.x - x
        let dy = destination.y - y
        let dz = destination.z - z
        return CGFloat(sqrt(dx*dx + dy*dy + dz*dz))
    }
    
    static func positionFrom(matrix: matrix_float4x4) -> SCNVector3 {
        let column = matrix.columns.3
        return SCNVector3(column.x, column.y, column.z)
    }
}
