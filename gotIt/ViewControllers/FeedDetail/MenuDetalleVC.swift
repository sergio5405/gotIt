//
//  MenuDetalleVC.swift
//  ObentoGo
//
//  Created by Sergio Hernandez Jr on 04/03/18.
//  Copyright © 2018 Sergio Hernandez. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase


class FeedDetailVC: UIViewController {
    var obento: Obento!
    var cantidad : UInt = 1
    
    @IBOutlet weak var obentoPrecioBtn: UIButton!
    @IBOutlet weak var obentoTituloLbl: UILabel!
    @IBOutlet weak var obentoDescripcionLbl: UILabel!
    @IBOutlet weak var cantidadLbl: UILabel!
    
    @IBAction func cantidadBtn(_ sender: UIStepper) {
        cantidad = UInt(sender.value)
        cantidadLbl.text = "Cantidad: \(self.cantidad)"
        obentoPrecioBtn.setTitle(String(format: "COMPRAR $%.02f", locale: Locale.current, arguments: [obento.precio*Double(self.cantidad)]), for: UIControlState.normal)
    }
	@IBAction func obentoComprarBtn(_ sender: Any) {
		let defaultStore = Firestore.firestore()
		let userID = Auth.auth().currentUser!.uid
		defaultStore.collection("carrito").document(userID).getDocument { (docCarro, errCarrito) in
			
			var cantidadNueva = Int(self.cantidad)
			var precioTotalNuevo = self.obento.precio*Double(self.cantidad)
			let obentoNuevo = self.obento
			var comentariosNuevo = ""
			
			if let carro = docCarro?.data(){
				print("scc \(carro)")
				if let obentosCarrito = carro["obentos"] as? [String: Any]{
					print("hola \(obentosCarrito)")
					if let obentoSelec = obentosCarrito[self.obento.id!] as? [String: Any]{
						canti
						print("hola2 \(obentoSelec)")
					}
				}
			}
			
			
			//Carrito vencido -> Vaciar carrito
			//Ya existe en el carrito -> actualizar cantidad
			//No existe en el carrito -> agregar
			
			let nuevoItem = CarritoItem(cantidad: cantidadNueva, precioTotal: precioTotalNuevo, obento: obentoNuevo!, comentarios: comentariosNuevo)
			Carrito.articulos[self.obento.id!] = nuevoItem
			
			let horaVigencia = Timestamp(date: Date(timeInterval: 1*60, since: Date()))
			
			do{
				let json = try Carrito.articulos.toJSON()
				defaultStore.collection("carrito").document(userID).setData(["obentos":json, "vigencia": horaVigencia])
//				defaultStore.collection("carrito").document(userID).setD
			}catch{
				print(error)
			}
			
//			defaultStore.collection("carrito").document(userID).updateData([self.obento.id: nuevoItem, "vigencia": timestamp])
		}
	}
	
    @IBOutlet weak var obentoImagenesHeaderView: MenuDetalleObentoHeaderV!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = obento.nombre.uppercased()
        self.obentoTituloLbl.text = obento.nombre.uppercased()
        self.obentoDescripcionLbl.text = obento.descripcion
        self.obentoPrecioBtn.setTitle(String(format: "COMPRAR $%.02f", locale: Locale.current, arguments: [obento.precio*Double(self.cantidad)]), for: UIControlState.normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryBoard.Detalle.MostrarImagenesSegue {
            if let imagesPageVC = segue.destination as? MenuDetalleObentoImagenPVC {
                imagesPageVC.imagenes = obento.imagenes
                imagesPageVC.pageViewControllerDelegate = obentoImagenesHeaderView
            }
        }
    }
}

extension Encodable{
	func toJSON(excluding keys: [String] = [String]()) throws -> [String: Any] {
		let objectData = try JSONEncoder().encode(self)
		let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
		guard var json = jsonObject as? [String: Any] else {
			return [String:Any]()
		}
		
		for key in keys{
			json[key] = nil
		}
		
		return json
	}
}

extension DocumentSnapshot{
	func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T{
		var documentJson = data()!
		if includingId {
			documentJson["id"] = documentID
 		}
		
		let documentData = try JSONSerialization.data(withJSONObject: documentJson, options: [])
		let decodedObject = try JSONDecoder().decode(objectType, from: documentData)
		
		return decodedObject
	}
}
