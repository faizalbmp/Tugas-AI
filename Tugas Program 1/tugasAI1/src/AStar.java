/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Comparator;
import java.util.HashMap;
import java.util.PriorityQueue;

/**
 *
 * @author bima
 */
public class AStar {
    private PriorityQueue<Node> openList;
    private ArrayList<Node> closedList;
    HashMap<Node, Double> gVals;
    HashMap<Node, Double> fVals;
    private int initialCapacity = 100;

    public AStar() {
        gVals = new HashMap<Node, Double>();
        fVals = new HashMap<Node, Double>();
        openList = new PriorityQueue<Node>(initialCapacity, new fCompare());
        closedList = new ArrayList<Node>();
    }

    public static void main(String[] args) {
        Node[] n = new Node[20];
        for (int i = 0; i < n.length; i++) {
            n[i] = new Node();
            n[i].setData("n-" + i);
        }
        
        n[0].setName("Ravenna");
        n[1].setName("Rimini");
        n[2].setName("ferrara");
        n[3].setName("forli");
        n[4].setName("Cesena");
        n[5].setName("Faenza");
        n[6].setName("Imola");
        n[7].setName("Emilia");
        n[8].setName("Terme");
        n[9].setName("Carpi");
        n[10].setName("Piacenza");
        n[11].setName("Bobbia");
        
        n[0].setH(0);
        n[1].setH(0.5);
        n[2].setH(5);
        n[3].setH(2);
        n[4].setH(4.5);
        n[5].setH(4);
        n[6].setH(5);
        n[7].setH(6);
        n[8].setH(7);
        n[9].setH(8);
        n[10].setH(10);
        n[11].setH(10.5);
        
        n[11].setNeighbors(n[10], 5);
        n[11].setNeighbors(n[8], 3);
        n[11].setNeighbors(n[4], 15);
        n[10].setNeighbors(n[9], 3);
        n[10].setNeighbors(n[8], 3);
        n[9].setNeighbors(n[7], 2);
        n[9].setNeighbors(n[5], 8);
        n[8].setNeighbors(n[7], 2);
        n[8].setNeighbors(n[5], 3);
        n[7].setNeighbors(n[6], 2);
        n[6].setNeighbors(n[5], 1);
        n[6].setNeighbors(n[3], 3);
        n[5].setNeighbors(n[3], 2);
        n[5].setNeighbors(n[4], 6);
        n[4].setNeighbors(n[1], 5);
        n[3].setNeighbors(n[4], 2);
        n[3].setNeighbors(n[0], 3);
        n[2].setNeighbors(n[0], 6);
        n[2].setNeighbors(n[6], 3);
        n[1].setNeighbors(n[0], 1);
        
        new AStar().traverse(n[11], n[0]);
    }

    public void traverse(Node start, Node end) {
        openList.clear();
        closedList.clear();

        gVals.put(start, 0.0);
        fVals.put(start, 0.0);
        openList.add(start);
        
        
        while (!openList.isEmpty()) {
            
            Node current = openList.element();
            System.out.println("open ketika best node akan di evaluasi :");
            printOpen(openList);
            System.out.println("");
            System.out.println("closed ketika best node akan di evaluasi :");
            printClosed(closedList);
            System.out.println("");
            System.out.println("Best Node yang akan di evaluasi ");
            System.out.print(current.getName());
            System.out.println("");
            if (current.equals(end)) {
                System.out.println("");
                System.out.println("");
                System.out.println("kota telah ditemukan");
                System.out.println("Jarak yang ditempuh = "+gVals.get(current));
                printPath(current);
                
                return;
            }
            closedList.add(openList.poll());
            ArrayList<Ketetanggaan> neighbors = current.getNeighbors();

            for (Ketetanggaan neighbor : neighbors) {
                double gScore = gVals.get(current) + neighbor.getJarak();
                double fScore = gScore + neighbor.getTetangga().getH();

                if (closedList.contains(neighbor)) {

                    if (gVals.get(neighbor) == null) {
                        gVals.put(neighbor.getTetangga(), gScore);
                    }
                    if (fVals.get(neighbor) == null) {
                        fVals.put(neighbor.getTetangga(), fScore);
                    }

                    if (fScore >= fVals.get(neighbor)) {
                        continue;
                    }
                }
                if (!openList.contains(neighbor) || fScore < fVals.get(neighbor)) {
                    neighbor.getTetangga().setParent(current);
                    gVals.put(neighbor.getTetangga(), gScore);
                    fVals.put(neighbor.getTetangga(), fScore);
                    if (!openList.contains(neighbor)) {
                        openList.add(neighbor.getTetangga());

                    }
                }
            }
            
            System.out.println("open ketika best node telah di evaluasi :");
            printOpen(openList);
            System.out.println("");
            
            System.out.println("closed ketika best node telah di evaluasi :");
            printClosed(closedList);
            System.out.println("");
            System.out.println("");
            System.out.println("");
        }
        System.out.println("FAIL");
    }

    private void printPath(Node node) {
        System.out.println("kota yang ditempuh : ");
        System.out.print(node.getName()+"   <-    ");
        while (node.getParent() != null) {
            node = node.getParent();
            System.out.print(node.getName()+"   <-   ");
        }
          
    }
    
    private void printOpen(PriorityQueue<Node> openList){
        System.out.print("[");
        for (Node openList1 : openList) {
            
            System.out.print(openList1.getName() + " = " + fVals.get(openList1) + " , ");
                    
        }
        System.out.print("]");
    }
    
    private void printClosed(ArrayList<Node> closedList){
        System.out.print("[");
        for (Node closedList1 : closedList) {
                
            System.out.print(closedList1.getName() + " = " + fVals.get(closedList1) + " , ");
       }
        System.out.print("]");
                
        
    }
    class fCompare implements Comparator<Node> {

        public int compare(Node o1, Node o2) {
            if (fVals.get(o1) < fVals.get(o2)) {
                return -1;
            } else if (fVals.get(o1) > fVals.get(o2)) {
                return 1;
            } else {
                return 1;
            }
        }
    }
}
    


class Node {

    private String name;
    private Node parent;
    private ArrayList<Ketetanggaan> neighbors;
    private double h;
    private Object data;

    public Node() {
        neighbors = new ArrayList<Ketetanggaan>();
        data = new Object();
    }

    public Node(double h) {
        this();
        this.h=h;
    }

    public Node(Node parent) {
        this();
        this.parent = parent;
    }

    public Node(Node parent, Float h) {
        this();
        this.parent = parent;
        this.h=h;
    }

    public ArrayList<Ketetanggaan> getNeighbors() {
        return neighbors;
    }

    public void setNeighbors(Node tetangga, int jarak) {
        Ketetanggaan k;
        k = new Ketetanggaan(tetangga, jarak);
        this.neighbors.add(k);
    }
    
    public void setName(String name){
        this.name = name;
    }
    
    public String getName(){
        return name;
    }
    
    public Node getParent() {
        return parent;
    }

    public void setParent(Node parent) {
        this.parent = parent;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public boolean equals(Node n) {
        return this.h == n.h;
    }
    public void setH(double h){
        this.h=h;
    }
    public double getH(){
        return h;
    }
} 

class Ketetanggaan{
    
    private Node tetangga;
    private int jarak;
    
    public Ketetanggaan(Node tetangga,int jarak){
        
        this.jarak = jarak;
        this.tetangga=tetangga;
    } 
    
    public void setJarak(int jarak){
        this.jarak=jarak;
    }
    
    public int getJarak(){
        return jarak;
    }
    
    public void setTetangga(Node Tetangga){
        this.tetangga=tetangga;
    }
    
    public Node getTetangga(){
        return tetangga;
    }
}
